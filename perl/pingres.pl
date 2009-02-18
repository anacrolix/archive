#!/usr/bin/perl

use Net::Ping;
use Time::HiRes;

$port = getservbyname('http','tcp');
$host = 'eruanno.com';

sub print_ping {
	my ($ret, $rtt, $ip) = @_;
    print join("\t",
    	$ret ? 'OK' : 'FAILED',
        $ip,
        sprintf('%.1f', $rtt*1000),
        ), "\n";
}

#tcp
$p = Net::Ping->new('tcp');
$p->{port_num} = $port;
$p->hires();
print_ping($p->ping($host));

#syn
$p = Net::Ping->new('syn');
$p->{port_num} = $port;
$p->hires();
$p->ping($host);
print_ping($p->ack);

#stream
$p = Net::Ping->new('stream');
$p->{port_num} = $port;
$p->hires();
print_ping($p->ping($host));

#stream pre-opened
$p = Net::Ping->new('stream');
$p->{port_num} = $port;
$p->hires();
$p->open($host);
print_ping($p->ping($host));

print "Script completed successfully.\n";