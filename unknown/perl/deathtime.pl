#!/usr/bin/perl -w

%months = (
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

#use Date::Manip;
use Time::Zone; #tz_offset
use Time::Local; #timelocal, timegm
use LWP::Simple; #get
use HTML::Entities; #encode/decode entities
use threads;
use threads::shared;
use URI::Escape; #uri_(un)?escape

#any non-tag symbol
my $re_nt = '[^<>]';
#extract link, name, level, vocation from character listing on world online page
my $re_char_html = "<tr$re_nt*?><td$re_nt*?><a href=\"([^\"]*)\">($re_nt+?)</a></td><td$re_nt*?>($re_nt*?)</td><td$re_nt*?>($re_nt*?)</td></tr>";
#opentag
my $re_otag = "<$re_nt*>";
#closetag
my $re_ctag = "</$re_nt*>";
# tibiatime_html, killer_most_damage, killer_last_hit?
my $re_char_death = "<tr$re_nt*><td$re_nt*>($re_nt+)</td><td>Killed at Level \\d+ by <a$re_nt*>($re_nt+)</a></td></tr>(?:$re_nt*$re_otag$re_otag$re_ctag$re_otag".'and by '."$re_otag($re_nt+)$re_ctag$re_ctag</tr>)?";
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%>May&#160;17&#160;2007,&#160;03:33:07&#160;CEST</TD><TD>Killed at Level 106 by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Athraz">Athraz</A></TD></TR>
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%></TD><TD>and by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Sir+Ucker">Sir&#160;Ucker</A></TD></TR>
# character level from char page
my $re_char_level = "<td>Level:</td><td>(\\d+)</td>";
#<TD>Level:</TD><TD>16</TD>
#<TR BGCOLOR=#D4C0A1><TD>Level:</TD><TD>113</TD></TR>
#vocation from char page
my $re_char_vocation = "<td>Profession:</td><td>($re_nt+)</td>";
#<TD>Profession:</TD><TD>Knight</TD>
my $link_world_online = 'http://www.tibia.com/community/?subtopic=whoisonline&world=';
my $link_char_page = 'http://www.tibia.com/community/?subtopic=characters&name=';
#http://www.tibia.com/community/?subtopic=characters&name=Athraz

#constants
my $MAX_THREADS = 20;

#globals
my %online;
my %char_html : shared;

#@char_names ($world_name)
sub get_online_list ($) {
    my ($world_name) = @_;
    my $world_html = get($link_world_online.$world_name) or die "get($link_world_online$world_name): $!";
    my @online_names;
    while ($world_html =~ m/$re_char_html/ig) {
        my $char_name = decode_entities($2);
        $char_name =~ tr/\xA0/ /;
    	push @online_names, $char_name;
    }
    return @online_names;
}

#unixutctime ($tibia_html_time)
sub gmtime_tibiatime_html ($) {
    my ($tibiatime_html) = @_;
    decode_entities($tibiatime_html);
    $tibiatime_html =~ m/^([A-Z][a-z]{2}).(\d+).(\d+),.(\d+):(\d+):(\d+).(\S+)$/ or die "Can't parse $tibiatime_html: $!";
    my $time = timegm($6, $5, $4, $2, $months{$1}, $3-1900);
    $time -= tz_offset($7) or die "Can't get tz_offset $7: $!";
    return $time;
}

sub char_name_to_link ($) {
    my ($char_name) = @_;
    $char_name =~ s/\xA0| /+/g;
    return $link_char_page.$char_name;
}

sub get_full_char ($) {
    my ($char_name) = @_;
    $online{$char_name}{link} = char_name_to_link($char_name) if not defined $online{$char_name}{link};
    my $char_html;
    if (defined $char_html{$char_name}) {
    	$char_html = $char_html{$char_name};
        undef $char_html{$char_name};
    } else {
     	$char_html = get($online{$char_name}{link}) or die "get($online{$char_name}{link}: $!";
    }
    $char_html =~ m|$re_char_level|i or warn "Level not found: $online{$char_name}{link}" and return;
    $online{$char_name}{level} = $1;
    $char_html =~ m|$re_char_vocation|i or warn "Vocation not found: $online{$char_name}{link}" and return;
    $online{$char_name}{vocation} = $1;
    $online{$char_name}{vocation} =~ tr/A-Z//cd;
    my @deaths;
    while ($char_html =~ m/$re_char_death/sig) {
    	my %death;
        $death{when} = gmtime_tibiatime_html($1);
        if (defined $3) {
#            print "$char_name death: $1\t$2\t$3\n";
#            print '$1=', $1, "\n";
#            print '$2=', $2, "\n";
#            print '$3=', $3, "\n";
	    ($death{longpz} = decode_entities($3)) =~ s/\xA0/ /;
            ($death{shortpz} = decode_entities($2)) =~ s/\xA0/ /;
        } else {
	    ($death{longpz} = decode_entities($2)) =~ s/\xA0/ /;
        }
        push @deaths, \%death;
    }
    undef $char_html;
    $online{$char_name}{deaths} = \@deaths;
}

sub print_recent_kill ($$$$) {
    my ($victim_name, $killer_name, $time_of_death, $pz_duration) = @_;
    my $pz_remaining = $time_of_death + $pz_duration - time;
    return if $pz_remaining < 0;
    warn;
    get_full_char($killer_name) if (not defined $online{$killer_name}{vocation} or not defined $online{$killer_name}{level});
    print $killer_name;
    print ' (', $online{$killer_name}{level}, ' ', $online{$killer_name}{vocation}, ')';
    print ' has ', int($pz_remaining/60+1), ' mins PZL for killing ',
    $victim_name, ' (', $online{$victim_name}{level}, ' ', $online{$victim_name}{vocation}, ') ',
    int((time-$time_of_death)/60), " mins ago.\n";
}

sub print_recent_kills ($) {
    my ($victim_name) = @_;
    foreach my $href_death (@{$online{$victim_name}{deaths}}) {
    	print_recent_kill($victim_name, $href_death->{longpz}, $href_death->{when}, 15*60);
        print_recent_kill($victim_name, $href_death->{shortpz}, $href_death->{when}, 2*60) if defined $href_death->{shortpz};
    }
}

sub get_char_html {
    my (@char_list) = @_;
    my @threads;
    foreach my $char_name (@char_list) {
    	push @threads, async {
	    $char_html{$char_name} = get(char_name_to_link($char_name));
	};
        if (scalar @threads > $MAX_THREADS) {
	    my $thread = shift @threads;
            $thread->join;
        }
    }
    $_->join foreach (@threads);
}

#sub print_char ($) {
#    my ($char_name) = @_;
#    print join("\t", $char_name}, $online{$char_name}{level}, $online{$char_name}{vocation}), "\n";
#
#}

#CONTEXT TESTING

#my @char_list = get_online_list('Dolera');
#my $start_time = time;
#foreach my $char_name (@char_list[0..9]) {
#    get(char_name_to_link($char_name));
#    print "get($char_name)\n";
#}
#print "Took ", time-$start_time, " seconds.\n";
#print char_name_to_link('blah\xa0sup\'hi');
#print "Testing Completed\n";
#exit;

#MAIN

my @char_list = get_online_list('Dolera');
#print join("\n",@char_list,'');
get_char_html(@char_list);
#foreach my $char_name (get_online_list('Dolera')) {
#    warn;
#    get_full_char($char_name);
#    print "Updated $char_name\n";
#    print_recent_kills ($char_name);
#}


#foreach my $victim_name ((keys %online)[0..10]) {
#    push @threads, threads->create('get_full_char', $victim_name);
#    if (scalar @threads >= $MAX_THREADS) {
#        my $thread = shift @threads;
#        $thread->join;
#    }
#}
#$_->join foreach (@threads);
#print scalar keys %online, " characters are online.\n";
#
foreach $victim_name (keys %online) {
    get_deaths (\%{$online{$victim_name}});
    print "Checking $victim_name for deaths : $online{$victim_name}{deaths}\n";
    if (defined $online{$victim_name}{deaths}) {
        foreach my $href_death (@{$online{$victim_name}{deaths}}) {
            print_recent_kill($victim_name, $href_death->{longpz}, $href_death->{when}, 15*60);
            print_recent_kill($victim_name, $href_death->{shortpz}, $href_death->{when}, 2*60) if defined $href_death->{shortpz};
        }
    }
}

print "Execution completed.\n";
