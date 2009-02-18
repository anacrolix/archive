#!/usr/bin/perl -w

use strict;
use LWP::Simple;
use HTML::Entities;
use threads;
use threads::shared;
use Date::Parse;
use Getopt::Std;

my %ENUM_MONTHS = (
		   Jan => 0,
		   Feb => 1,
		   Mar => 2,
		   Apr => 3,
		   May => 4,
		   Jun => 5,
		   Jul => 6,
		   Aug => 7,
		   Sep => 8,
		   Oct => 9,
		   Nov => 10,
		   Dec => 11);

my $LINK_WORLD_ONLINE_LIST = 'http://www.tibia.com/community/?subtopic=whoisonline&world=';
my $LINK_CHAR_PAGE = 'http://www.tibia.com/community/?subtopic=characters&name=';
my $MAX_THREADS = 20;
my $POLL_INTERVAL = 1*60;
my $WORLD = 'Dolera';
my $RE_WORLD_ONLINE_LIST_CHAR = '<TR BGCOLOR=#[0-9A-Za-z]+><TD WIDTH=70%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">([^<>]+)</A></TD><TD WIDTH=10%>\d+</TD><TD WIDTH=20%>([^<>]+)</TD></TR>';
#<TR BGCOLOR=#D4C0A1><TD WIDTH=70%><A HREF="http://www.tibia.com/community/?subtopic=characters&name=Lowix">Lowix</A></TD><TD WIDTH=10%>165</TD><TD WIDTH=20%>Royal Paladin</TD></TR>
my $RE_CHAR_PAGE_LEVEL = '<TD>Level:</TD><TD>(\d+)</TD>';
#<TD>Level:</TD><TD>16</TD>
my $RE_CHAR_PAGE_VOCATION = '<TD>Profession:</TD><TD>([^<>]+)</TD>';
#<TD>Profession:</TD><TD>Knight</TD>
my $RE_CHAR_PAGE_DEATH = '<TR BGCOLOR=#[A-Za-z0-9]+><TD WIDTH=25%>([^<>]+)</TD><TD>(?:Killed|Died)? at Level \d+ by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">)?([^<>]+)(?:</A>)?</TD></TR>(?:\s+<TR BGCOLOR=#[0-9A-Za-z]+><TD WIDTH=25%></TD><TD>and by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">)?([^<>]+)(?:</A>)?</TD></TR>)?';
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%>Jun&#160;10&#160;2007,&#160;08:48:28&#160;CEST</TD><TD>Killed at Level 51 by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Orelius">Orelius</A></TD></TR>
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%></TD><TD>and by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Maiden+Juliet">Maiden&#160;Juliet</A></TD></TR>
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%>May&#160;18&#160;2007,&#160;06:20:50&#160;CEST</TD><TD>Killed at Level 44 by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Bones%27Sage">Bones'Sage</A></TD></TR>
#<TR BGCOLOR=#D4C0A1><TD WIDTH=25%>May&#160;25&#160;2007,&#160;13:01:22&#160;CEST</TD><TD>Died at Level 48 by a necromancer</TD></TR>

my %opts;
getopts('t:w:i:', \%opts);
$MAX_THREADS = $opts{t} if defined $opts{t};
$WORLD = ucfirst $opts{w} if defined $opts{w};
$POLL_INTERVAL = $opts{i} if defined $opts{i};
$|=1;

sub get_world_online_list ($$) {
    my ($world_name, $incl_novoc) = @_;
    my $world_link = $LINK_WORLD_ONLINE_LIST . $world_name;
    my $world_html = get($world_link)
    	or die "get($world_link): $!";
    my @char_names;
    while ($world_html =~ m|$RE_WORLD_ONLINE_LIST_CHAR|g) {
      	my $char_name = $1;
	next if not $incl_novoc and $2 eq 'None';
        decode_entities($char_name);
#        print "$char_name\n";
#        print length $char_name, "\n";
        $char_name =~ tr/\xA0/ /;
#        for (my $i = 0; $i < length $char_name; $i++) {
#            print sprintf('%0X', ord(substr $char_name, $i, 1));
#        }
#        print "\n";
	push @char_names, $char_name;
    }
    return @char_names;
}



sub get_char_page_link ($) {
    my ($char_name) = @_;
    $char_name =~ tr/ /+/;
    return $LINK_CHAR_PAGE . $char_name;
}

sub print_progress ($$@) {
    my ($cur, $end, @pre) = @_;
    my $percent = int($cur/$end*100);
    my $str_progress = $percent >= 100 ? 'Done.' : sprintf('[%2d%%]', $percent);
    print "\r";
    print @pre if @pre;
    print $str_progress;
}

sub get_char_page_html ($$@) {
    my ($href_char_page_html, $show_progress, @char_names) = @_;
#    print $href_char_page_html, "\n";
    my @threads;
    #my $char_name;
    my ($done, $total, $job_name) = (0, scalar @char_names, sprintf('Querying %3d characters: ', scalar @char_names));
    print_progress($done, $total, $job_name) if $show_progress;
    if ($MAX_THREADS >= 2) {
	foreach my $char_name (@char_names) {
	    my $char_page_link = get_char_page_link($char_name);
	    if (scalar @threads >= $MAX_THREADS) {
		my $thread = shift @threads;
		$thread->join;
		print_progress(++$done, $total, $job_name) if $show_progress;
	    }
	    push @threads, async {
#            my %source : shared = (age => time, src => get($char_page_link));
#            $$href_char_page_html{$char_name} = \%source;
			$$href_char_page_html{$char_name} = get($char_page_link) or die "$char_page_link $!";
#            print $$href_char_page_html{$char_name}, "\n";
	    };
#    print $char_page_link, "\n";
	}
	foreach my $t (@threads) {
	    $t->join;
	    print_progress(++$done, $total, $job_name) if $show_progress;
	}
    } else {
	foreach my $char_name (@char_names) {
	    $$href_char_page_html{$char_name} = get(get_char_page_link($char_name));
	    print_progress(++$done, $total, $job_name) if $show_progress;
	}
    }
    my $html_size = 0;
    $html_size += length $$href_char_page_html{$_} foreach @char_names;
    print sprintf(" (%d KB)\n", int($html_size/1000)) if $show_progress;
}

sub html2plain ($) {
    my ($html) = @_;
    decode_entities($html);
    $html =~ tr/\xA0/ /;
    return $html;
}

sub parse_char_page_html ($$@) {
    my ($href_char_stats, $href_char_page_html, @char_names) = @_;
    foreach my $char_name (@char_names) {
	my %char;
	my $html = delete $$href_char_page_html{$char_name};
	$html =~ m|$RE_CHAR_PAGE_LEVEL| or die "$html\nCan't match level for $char_name";
	$char{level} = $1;
	$html =~ m|$RE_CHAR_PAGE_VOCATION| or die "Can't match vocation for $char_name";
	$char{vocation} = $1;
	$char{vocation} =~ tr/A-Z//cd;
	while ($html =~ m|$RE_CHAR_PAGE_DEATH|g) {
	    my @death_vars = ($1, $2, $3, $4, $5);
	    #print join("\n", @death_vars, '');
	    my %death;
	    $death{timestamp} = str2time(html2plain($death_vars[0]));
	    #$death{monster} = $death_vars[1] =~ m/^Died$/;
	    if (defined $death_vars[4]) {
		$death{lasthit}{name} = html2plain($death_vars[4]);
		$death{lasthit}{isplayer} = defined $death_vars[3];
		$death{mostdamage}{name} = html2plain($death_vars[2]);
		$death{mostdamage}{isplayer} = $death_vars[1] ne '';
	    } else {
		$death{lasthit}{name} = html2plain($death_vars[2]);
		$death{lasthit}{isplayer} = defined $death_vars[1];
	    }
	    push @{$char{deaths}}, \%death;
	}
	#print %char, "\n";
	$$href_char_stats{$char_name} = \%char;
	#print $$href_char_stats{$char_name}{level}, "\n";
    }
}

sub print_char_info ($@) {
    my ($href_char_info, @char_names) = @_;
    foreach my $char_name (@char_names) {
	print("$char_name: $$href_char_info{$char_name}{level} $$href_char_info{$char_name}{vocation}\n");
	foreach (@{$$href_char_info{$char_name}{deaths}}) {
	    #next unless $$_{timestamp}+15*60 > time;
	    print "$$_{timestamp} ", scalar gmtime($$_{timestamp}+2*3600);
	    print " Killed by";
	    print " $$_{mostdamage}{name}", $$_{mostdamage}{isplayer}?'':" (Monster)", ' and by' if defined $$_{mostdamage};
	    print " $$_{lasthit}{name}",$$_{lasthit}{isplayer}?'':" (Monster)";
	    print "\n";
	}
    }
}

sub get_char_info ($) {
    my ($char_name) = @_;
    get_char_page_html($char_name);
    parse_char_page_html($href_char_info, $href_char_page_html, @char_names);
    #print $$href_char_info{'Rodies Druid'}{level}, "\n";
}

sub print_death ($$) {
    my ($death, $char_name) = @_;
    print scalar localtime($$death{timestamp}), ':';
#    print " $char_name ($$href_char_info{$char_name}{level} $$href_char_info{$char_name}{vocaction})";
    print " $char_name ($$href_char_info{$char_name}{level} $$href_char_info{$char_name}{vocation}) was killed by";
    my $killer_name;
    if (defined $$death{mostdamage}) {
    	$killer_name = $$death{mostdamage}{name};
    	get_char_info($href_char_info, $href_char_page_html, $killer_name) if $$death{mostdamage}{isplayer} and not defined $$href_char_info{$killer_name};
    	print " $killer_name";
        print " ($$href_char_info{$killer_name}{level} $$href_char_info{$killer_name}{vocation})" if $$death{mostdamage}{isplayer};
        print ' and by';
    }
    $killer_name = $$death{lasthit}{name};
    get_char_info($href_char_info, $href_char_page_html, $killer_name) if $$death{lasthit}{isplayer} and not defined $$href_char_info{$killer_name};
    print " $killer_name";
    print " ($$href_char_info{$killer_name}{level} $$href_char_info{$killer_name}{vocation})" if $$death{lasthit}{isplayer};
    print "\n";
}

sub print_pz_locked ($$@) {
    my ($href_char_info, $href_char_page_html, @char_names) = @_;
    foreach my $char_name (@char_names) {
	foreach my $death (@{$$href_char_info{$char_name}{deaths}}) {
	    next unless $$death{timestamp} > time-15*60;
	    print_death($href_char_info, $href_char_page_html, $death, $char_name);
	}
    }
}

my %char_info;
my $time_this_update = time;
my $time_last_update = time-15*60;
my $time_data_age;

while (1) {
    $time_data_age = time;
#    print "Updating at ", scalar localtime, "\n";
	my @online_chars = get_world_online_list($WORLD, 0);
    print "\nChecking ", scalar @online_chars, " characters...\n";
    foreach my $char_name (@online_chars) {
    	get_char_page_html(\%char_page_html, 0, $char_name);
    	#print(length($char_page_html{$_}), "\n") foreach (keys %char_page_html);
    	parse_char_page_html(\%char_info, \%char_page_html, $char_name);
#    print "Printing deaths after ", scalar localtime($time_last_update), "\n";
    	print_pz_locked(\%char_info, \%char_page_html, $char_name);
	}
    $time_last_update = $time_data_age;
	print "Update took ", time-$time_data_age, " seconds.\n";
    sleep(1) while (time < $time_this_update + $POLL_INTERVAL);
    $time_this_update += $POLL_INTERVAL;
    print "\n";
}
print "Execution completed.\n";