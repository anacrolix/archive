#!/usr/bin/perl

use Net::Ping;
use Time::HiRes;

sub tcp_ping ($$) {
    my ($host, $port) = @_;
    my $pinger = Net::Ping->new('tcp');
    $pinger->{port_num} = $port;
    $pinger->hires();
    return $pinger->ping($host);
}

sub syn_ping ($$) {
	my ($host, $port) = @_;
    my $pinger = Net::Ping->new('syn');
    $pinger->{port_num} = $port;
    $pinger->hires();
    $pinger->ping($host);
    return $pinger->ack();
}

sub print_ping (@) {
	my ($ret, $rtt, $ip) = @_;
    printf("$host [$ip] - %.2f ms\n", 1000 * $rtt);
}

$host = '67.15.99.105';
$port = 7171;
$repeats = 100;
$syn_sum = 0;
$tcp_sum = 0;

for (1..$repeats) {
	$syn_sum += (syn_ping($host, $port))[1];
    $tcp_sum += (tcp_ping($host, $port))[1];
}

$tcp_av = $tcp_sum / $repeats;
$syn_av = $syn_sum / $repeats;

printf("AV(SYN_PING) %.2f\n", 1000 * $syn_av);
printf("AV(TCP_PING) %.2f\n", 1000 * $tcp_av);

