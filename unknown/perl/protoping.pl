#!/usr/bin/perl -w

my $host = shift;
my $rem_port = shift;
#my $my_addr;

print "Host: $host\nRemote port: $rem_port\n";

use Net::Ping;
use Time::HiRes;
use strict;

# tcp

my $tcp = Net::Ping->new("tcp");
$tcp->hires();
$tcp->{port_num} = $rem_port;
print "TCP ping: ", &printPingResults($host, $tcp->ping($host)), "\n";
$tcp->close();

# udp

#print "

# icmp
# stream
# syn

my $syn = Net::Ping->new("syn");
$syn->{port_num} = $rem_port;
$syn->hires();
print "SYN ping: ", &printPingResults($host, $syn->ping($host)), "\n";

# external

sub printPingResults () {
    my ($host, $ret, $rtt, $ip) = @_;
    print join ' ', @_;
    if ($ret eq '0') {
	return "$host [$ip] did not reply.";
    } elsif ($ret) {
	return sprintf "$host [$ip] responded in %.3fms.", 1000 * $rtt;
    } else {
	return "$host could not be resolved.";
    }	
}
