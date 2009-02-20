#!/usr/bin/perl

use IO::Select;
use IO::Socket::INET;
use IO::Pipe;

my $SERVER_PORT = 50000;

$pipe = new IO::Pipe;
my $pid = fork();
die "Can't fork: $!" if not defined $pid;
if ($pid) {
	$pipe->writer();
    select $pipe;
    $|=1;
    for (;;) {
    	sleep(1);
        print "Hello my child!\n";
    }
} else {
	$pipe->reader();
    my $server = new IO::Socket::INET(
		Listen => SOMAXCONN,
        Proto => 'tcp',
        LocalPort => $SERVER_PORT,
        ReuseAddr => 1
        );
    my $select = new IO::Select($pipe, $server);
    while (@ready = $select->can_read) {
    	foreach my $fh (@ready) {
        	if ($fh == $server) {
            	print "Server reading\n";
                if (my $client = $server->accept) {
                	$select->add($client);
                }
            } elsif ($fh == $pipe) {
            	print "Pipe reading\n";
                print $pipe->getline;
            } else {
            	$select->remove($fh);
                $fh->close;
            }
        }
    }
}