#!/usr/bin/perl

use LWP::Simple;
use HTML::Entities;
use threads;
use threads::shared;
use strict;
use File::Copy;

my $output_filename = 'httpdocs/muck/global.html';
open(CACHED, '>', "$output_filename.$$") or die "pid $$, $!";
print CACHED<<EOF;
<html>
<head>
<title>Tibia Global Online List</title>
<style type="text/css">
table#stat th{text-align:left}
</style>
</head>
<body>
EOF
#print scalar (getlogin || getpwuid($<) || "Kilroy"), "<br/>\n";
my $worldlist_html = get('http://www.tibia.com/community/?subtopic=whoisonline');
my @worlds;
while ($worldlist_html =~ m|http://www.tibia.com/community/\?subtopic=whoisonline&world=([A-Z][a-z]+)|ig) {
	push @worlds, [$1, $&];
}
undef $worldlist_html;
print "Found ", scalar @worlds, " worlds\n";

my $rent = '[^<>]';
my $re_char = "<tr$rent*?><td$rent*?><a$rent*?>($rent+?)</a></td><td$rent*?>($rent*?)</td><td$rent*?>($rent*?)</td></tr>";
undef $rent;

#get world online list html
my $start_time = time;
my @global_online : shared;
my @threads;
foreach (@worlds) {
	push @threads, async {
    	my $world_html = get($$_[1]);
        my $world_pop = 0;
        while ($world_html =~ m|$re_char|sig) {
        	my %char : shared = (name => decode_entities($1), level => $2, vocation => $3);
        	push @global_online, \%char;
            $world_pop++;
        }
        };
}
foreach (@threads) {
	$_->join();
}
#print "</ul>\n";
#print "<p>Get operation took ", time - $start_time, " seconds</p>\n";
&print_statistics;
&print_online;

print CACHED<<EOF;
</body>
</html>
EOF
close CACHED;
move("$output_filename.$$", $output_filename) or die $!;
print "Execution completed successfully.\n";

sub print_statistics {
	print CACHED "<h1>Statistics</h1>\n";
    print CACHED "<table id=\"stat\">\n";
    print CACHED "<tr><th>Current Time</th><td>", scalar gmtime, "</td></tr>\n";
	print CACHED "<tr><th>Global population</th><td>", scalar @global_online, "</td></tr>\n";
	my $sum_levels = 0;
	foreach my $char (@global_online) {
	    $sum_levels += $char->{level};
	}
	print CACHED "<tr><th>Average level</th><td>", $sum_levels / scalar @global_online, "</td></tr>\n";
    print CACHED "</table>\n";
}

sub print_online {
	print CACHED "<h1>Online List</h1>\n";
	print CACHED "<table><tr><th>Name</th><th>Level</th><th>Vocation</th></tr>\n";
	foreach my $char (sort {$b->{level} <=> $a->{level}} @global_online) {
	    print CACHED "<tr>";
	    for (encode_entities($char->{name}), $char->{level}, $char->{vocation}) {
	        print CACHED "<td>$_</td>";
	    }
	    print CACHED "</tr>\n";
	}
	print CACHED "</table>";
}