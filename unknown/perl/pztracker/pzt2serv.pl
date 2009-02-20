#!/usr/bin/perl -w

use strict;
use IO::Socket;
use IO::Handle;
use Getopt::Std;
use IO::Select;

my $SERVER_PORT = 63000;
my $INPUT_FILE = 'pz.out';

my $server = new IO::Socket::INET 
    (Proto => "tcp",
     LocalPort => $SERVER_PORT,
     Listen => SOMAXCONN,
     ReuseAddr => 1
     );
die "Failed to setup server: $!" unless $server;
open my $file, '<', $INPUT_FILE;
die "Couldn't open $INPUT_FILE: $!" unless $file;
my $select = new IO::Select($server, $file);
close STDERR;
close STDOUT;
close STDIN;

for (;;) {
    while (my @ready = $select->can_read) {
	foreach my $fh (@ready) {
	    if ($fh == $server) {
		my $client = $server->accept;
		die "Accept: $!" unless $client;
		$select->add($client);
		$client->autoflush;
		print $client "Welcome to EruPZ-Tracker 1.0!\015\012";
	    } elsif ($fh == $file) {	
		my $input;
		while ($input = <$file>) {
		    chomp $input;
		    $input .= "\015\012";
		    foreach my $client ($select->handles) {
			print $client $input if $client != $server and $client != $file;
		    }		
#		    print $input;
		}
		sleep(1) and $file->clearerr() and next if not defined $input;
	    } else {
		$select->remove($fh);
		$fh->close;
	    }
	}
    }
}
#		sleep(1);
#		$file->clearerr();

