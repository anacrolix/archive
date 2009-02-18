#!/usr/bin/perl -w

use strict;
use Socket;

my $port = shift || 6112;
my $proto = getprotobyname('tcp');

socket (SERVER, PF_INET, SOCK_STREAM, $proto) or die "socket: $!";
setsockopt (SERVER, SOL_SOCKET, SO_REUSEADDR, 1) or die "setsockopt: $!";

my $paddr = sockaddr_in($port, INADDR_ANY);

bind (SERVER, $paddr) or die "bind: $!";
listen (SERVER, SOMAXCONN) or die "listen: $!";
print "SERVER started on port $port";

my $client_addr;
while ($client_addr = accept(CLIENT, SERVER)) {
    my ($client_port, $client_ip) = sockaddr_in($client_addr);
    my $client_ipnum = inet_ntoa($client_ip);
    my $client_host = gethostbyaddr($client_ip, AF_INET);
    print "got a connection from: $client_host", "[$client_ipnum]";
    print CLIENT "Smile from the server :)\n";
    close CLIENT;
}
