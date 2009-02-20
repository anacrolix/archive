#!/usr/bin/perl -w

use strict;
use LWP::Simple;
use HTML::Entities;
use Date::Parse;
use Getopt::Std;
use IO::Select;
use IO::Socket::INET;
use IO::Handle;
use IO::Pipe;

my %opts;
getopts('w:p:l:d:', \%opts) or die "getopts: $!";
# w = world name
# p = port to listen, implies server-mode
# l = log file
# d = debug level, 0=critical, 1=warning, 2=notice, 3=debug

# ARG L
if (not defined $opts{l}) {
    open(LOG, '>>&', \*STDERR) or die "Can't dupe log to stderr: $!";
} else {
    open(LOG, '>>', $opts{l}) or die "Can't append log to $opts{l}: $!";
    LOG->autoflush;
    open(STDERR, '>>&', \*LOG) or die "Can't send stderr to $opts{l}: $!";
}

# ARG D
my $LOG_LEVEL = 0;
$LOG_LEVEL = $opts{d} if defined $opts{d};

sub plog($@) {
    my ($log_level, @log) = @_;
    return if $log_level > $LOG_LEVEL;
    print LOG scalar localtime, " [$$] ", @log, "\n";
}

# ARG P - SETUP SERVER

my $pipe;
if (defined $opts{p}) {
    $pipe = new IO::Pipe;
    my $pid = fork();
    die "Can't fork: $!" if not defined $pid;
    if ($pid) {
	$pipe->writer();
	select $pipe;
	$|=1;
	close STDIN;
    } else {
	$pipe->reader();
	close STDOUT;
	close STDIN;
	my $server = new IO::Socket::INET
	    (Listen => SOMAXCONN,
	     Proto =>'tcp',
	     LocalPort => $opts{p},
	     ReuseAddr => 1
	     );
	my $select = new IO::Select($pipe, $server);
	while (my @ready = $select->can_read) {
	    foreach my $fh (@ready) {
		if ($fh == $server) {
		    #print "Server reading\n";
		    if (my $client = $server->accept) {
			plog(1, $client->peerhost, ':', $client->peerport, ' has connected.');
			$select->add($client);
			$client->autoflush(1);
			print $client
			    "Welcome to Eru PZ Tracker 2.1!\015\012",
			    "Please wait and you will be informed of deaths as they become known.\015\012";
		    }
		} elsif ($fh == $pipe) {
		    #print "Reading from pipe\n";
		    while (defined(my $input = $pipe->getline)) {
			chomp $input;
			plog(1, $input);
			#print $pipe->getline;
			foreach my $client ($select->handles) {
			    next if ($client == $pipe or $client == $server);
			    $client->print($input, "\015\012");
			}
		    }
		} else {
		    plog(1, $fh->peerhost, ':', $fh->peerport, ' disconnected.');
		    $select->remove($fh);
		    $fh->close;
		}
	    }
	}
    }
} else {
    # not a server
    $|=1;
    close STDIN;
}

my $WORLD_NAME = 'Dolera';
$WORLD_NAME = ucfirst $opts{w} if defined $opts{w};

my $LINK_WORLD_ONLINE_LIST = 'http://www.tibia.com/community/?subtopic=whoisonline&world=';
my $LINK_CHAR_PAGE = 'http://www.tibia.com/community/?subtopic=characters&name=';
my $RE_WORLD_ONLINE_LIST_CHAR = '<TR BGCOLOR=#[0-9A-Za-z]+><TD WIDTH=70%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">([^<>]+)</A></TD><TD WIDTH=10%>(\d+)</TD><TD WIDTH=20%>([^<>]+)</TD></TR>';
#<TR BGCOLOR=#D4C0A1><TD WIDTH=70%><A HREF="http://www.tibia.com/community/?subtopic=characters&name=Lowix">Lowix</A></TD><TD WIDTH=10%>165</TD><TD WIDTH=20%>Royal Paladin</TD></TR>
my $RE_CHAR_PAGE_LEVEL = '<TD>Level:</TD><TD>(\d+)</TD>';
#<TD>Level:</TD><TD>16</TD>
my $RE_CHAR_PAGE_VOCATION = '<TD>Profession:</TD><TD>([^<>]+)</TD>';
#<TD>Profession:</TD><TD>Knight</TD>
my $RE_CHAR_PAGE_GUILD = '<TR BGCOLOR=#[0-9A-Za-z]+><TD>Guild&#160;membership:</TD><TD>[^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=guilds&page=view&GuildName=[^\"]+">([^<>]+)</A></TD></TR>';
#<TR BGCOLOR=#F1E0C6><TD>Guild&#160;membership:</TD><TD>Family of the <A HREF="http://www.tibia.com/community/?subtopic=guilds&page=view&GuildName=Ruff+Ryders">Ruff&#160;Ryders</A></TD></TR>
my $RE_CHAR_PAGE_DEATH = '<TR BGCOLOR=#[A-Za-z0-9]+><TD WIDTH=25%>([^<>]+)</TD><TD>(?:Killed|Died)? at Level \d+ by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">)?([^<>]+)(?:</A>)?</TD></TR>(?:\s+<TR BGCOLOR=#[0-9A-Za-z]+><TD WIDTH=25%></TD><TD>and by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">)?([^<>]+)(?:</A>)?</TD></TR>)?';
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%>Jun&#160;10&#160;2007,&#160;08:48:28&#160;CEST</TD><TD>Killed at Level 51 by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Orelius">Orelius</A></TD></TR>
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%></TD><TD>and by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Maiden+Juliet">Maiden&#160;Juliet</A></TD></TR>
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%>May&#160;18&#160;2007,&#160;06:20:50&#160;CEST</TD><TD>Killed at Level 44 by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Bones%27Sage">Bones'Sage</A></TD></TR>
#<TR BGCOLOR=#D4C0A1><TD WIDTH=25%>May&#160;25&#160;2007,&#160;13:01:22&#160;CEST</TD><TD>Died at Level 48 by a necromancer</TD></TR>

my %char_info;
my %last_print;

sub thtml2plain ($) {
    my ($html) = @_;
    decode_entities($html);
    $html =~ tr/\xA0/ /;
    return $html;
}

sub abbr_vocation ($) {
    my ($vocation) = @_;
    $vocation =~ tr/A-Z//cd;
    return $vocation;
}

sub hash_world_online_list ($) {
    my ($world_name) = @_;
    my $world_link = $LINK_WORLD_ONLINE_LIST . $world_name;
    my $world_html = get($world_link) or die "get($world_link): $!";
    my %online_chars;
    while ($world_html =~ m|$RE_WORLD_ONLINE_LIST_CHAR|g) {
    	my $char_name = thtml2plain($1);
        $online_chars{$char_name}{level} = $2;
        $online_chars{$char_name}{vocation} = abbr_vocation($3);
        $char_info{$char_name} = $online_chars{$char_name} if not defined $char_info{$char_name};
    }
    return %online_chars;
}

sub get_char_page_link ($) {
    my ($char_name) = @_;
    $char_name =~ tr/ /+/;
    return $LINK_CHAR_PAGE . $char_name;
}

sub get_char_page_html ($) {
    my ($char_name) = @_;
    return get(get_char_page_link($char_name));
}

sub parse_char_page_html ($$) {
    my ($html, $char_name) = @_;
    my %char;
    $html =~ m|$RE_CHAR_PAGE_LEVEL| or die "Can't match level: $char_name";
    $char{level} = $1;
    $html =~ m|$RE_CHAR_PAGE_VOCATION| or die "Can't match vocation: $char_name";
    $char{vocation} = abbr_vocation($1);
    if ($html =~ m|$RE_CHAR_PAGE_GUILD|) {
    	$char{guild} = thtml2plain($1);
    }
    while ($html =~ m|$RE_CHAR_PAGE_DEATH|g) {
	my @death_vars = ($1, $2, $3, $4, $5);
	my %death;
	$death{timestamp} = str2time(thtml2plain($death_vars[0]));
	if (defined $death_vars[4]) {
	    $death{lasthit}{name} = thtml2plain($death_vars[4]);
	    $death{lasthit}{isplayer} = defined $death_vars[3];
	    $death{mostdamage}{name} = thtml2plain($death_vars[2]);
	    $death{mostdamage}{isplayer} = $death_vars[1] ne '';
	} else {
	    $death{lasthit}{name} = thtml2plain($death_vars[2]);
	    $death{lasthit}{isplayer} = defined $death_vars[1];
	}
	push @{$char{deaths}}, \%death;
    }
    return %char;
}

sub print_new_deaths ($) {
    my ($char_name) = @_;
    $last_print{$char_name} = time-20*60 if not defined $last_print{$char_name};
    foreach my $death (@{$char_info{$char_name}{deaths}}) {
	next unless $$death{timestamp} > $last_print{$char_name};
	print_death($char_name, $death);
    }
    $last_print{$char_name} = $char_info{$char_name}{updated};
}

#sub print_char_info ($@) {
#    my ($href_char_info, @char_names) = @_;
#    foreach my $char_name (@char_names) {
#    print("$char_name: $$href_char_info{$char_name}{level} $$href_char_info{$char_name}{vocation}\n");
#        foreach (@{$$href_char_info{$char_name}{deaths}}) {
#next unless $$_{timestamp}+15*60 > time;
#            print "$$_{timestamp} ", scalar gmtime($$_{timestamp}+2*3600);
#            print " Killed by";
#            print " $$_{mostdamage}{name}", $$_{mostdamage}{isplayer}?'':" (Monster)", ' and by' if defined $$_{mostdamage};
#            print " $$_{lasthit}{name}",$$_{lasthit}{isplayer}?'':" (Monster)";
#            print "\n";
#        }
#    }
#}

sub get_char_str ($) {
    my ($char_name) = @_;
    my $str = $char_name;
    my (@char_tags) = (
		       $char_info{$char_name}{level},
		       $char_info{$char_name}{vocation},
		       $char_info{$char_name}{guild});
    my @left_tags = ();
    foreach my $tag (@char_tags[0,1]) {
    	push @left_tags, $tag if defined $tag;
    }
    my @right_tags = ();
    push @right_tags, $char_tags[2] if defined $char_tags[2];
    my $str_inner = join('-', join(' ', @left_tags), @right_tags);
    if ($str_inner) {
    	$str .= ' (' . $str_inner . ')';
    }
    return $str;
}

sub print_death ($$) {
    my ($char_name, $death) = @_;
    my $death_str = '';
    $death_str .= scalar localtime($$death{timestamp});
    $death_str .= ':';
    $death_str .= ' ' . get_char_str($char_name) . " killed by\n" . ' 'x25;
    #get player killer names
    my @killer_names = ();    
    if (defined $$death{mostdamage} and $$death{mostdamage}{isplayer}) {
	push @killer_names, $$death{mostdamage}{name};
    }
    push @killer_names, $$death{lasthit}{name} if ($$death{lasthit}{isplayer});
    #retrieve and process killers if they don't exist
    foreach my $killer_name (@killer_names) {
	next if (defined $char_info{$killer_name});
	update_char_info($killer_name);
	print_new_deaths($killer_name);
    }
    my $killer_name;
    if (defined $$death{mostdamage}) {
	$killer_name = $$death{mostdamage}{name};
        if ($$death{mostdamage}{isplayer}) {
	    $death_str .= ' ' . get_char_str($killer_name);
        } else {
	    $death_str .= " $killer_name";
        }
        $death_str .= " and by\n" . ' 'x25;
    }
    $killer_name = $$death{lasthit}{name};
    if ($$death{lasthit}{isplayer}) {
    	$death_str .= ' ' . get_char_str($killer_name);
    } else {
    	$death_str .= " $killer_name";
    }
    $death_str .= "\n";
    print $death_str;
}

sub update_char_info ($) {
    my ($char_name) = @_;
    my $update_time = time;
    my $char_html = get_char_page_html($char_name);
    my %char = parse_char_page_html($char_html, $char_name);
    $char{updated} = $update_time;
    $char_info{$char_name} = \%char;
}

my $time_last_update = time;
while (1) {
    my %list = hash_world_online_list($WORLD_NAME);
    plog(1, $WORLD_NAME, ' has ', scalar keys %list, ' characters online');
    foreach (sort keys %list) {
	next if $list{$_}{vocation} eq 'N';
	plog(2, "Processing $_");
	update_char_info($_);
	print_new_deaths($_);
    }
    sleep(1) while (time < $time_last_update + 60);
    $time_last_update += 60;
}
#    update_char_info('Orelius');
#    print_new_deaths('Orelius');
#    print "Execution completed.\n";
