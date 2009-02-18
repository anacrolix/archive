#!/usr/bin/perl -w

use strict;
use warnings;
#use diagnostics;

use Compress::Zlib;
use Net::HTTP::NB;
use Date::Parse;

my $nbr = new Net::HTTP::NB(Host => 'www.tibia.com') or die $@;
$nbr->keep_alive(1);
$nbr->send_te(1);
$nbr->write_request(GET => '/community/?subtopic=whoisonline&world=Dolera&order=level');
my ($code, $mess, %headers) = $nbr->read_response_headers();
print $code, ' ', $mess, "\n";
foreach my $header (keys %headers) {
    print $header, ': ', $headers{$header}, "\n";
}
my ($body, $buf);
while ($nbr->read_entity_body($buf, 0x1000)) {
    $body .= $buf;
}
print "\nReceived this many bytes: ", length $body, "\n";
print "gmtime: ", time, "; ", str2time($headers{Date}), "\n";

print $nbr->get_trailers;

