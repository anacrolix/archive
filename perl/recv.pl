#!/usr/bin/perl -w

use strict;
use Socket;
use Digest::MD5 qw(md5_hex);

#process parameters and prepare listen socket

my $lport = shift || 0;

socket(SERVER, PF_INET, SOCK_STREAM, getprotobyname('tcp')) || die "socket: $!";
setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, pack("l", 1)) || die "setsockopt: $!";
bind(SERVER, sockaddr_in($lport, INADDR_ANY)) || die "bind: $!";
listen(SERVER, SOMAXCONN) || die "listen: $!";

#report on local socket

my ($lsockaddr, $laddr, $lname);

print "Requested port: $lport\n";
$lsockaddr = getsockname(SERVER) || die "getsockname: $!";
($lport, $laddr) = sockaddr_in($lsockaddr);
$lname = gethostbyaddr($laddr, AF_INET);
print "Listening on [", inet_ntoa($laddr), ":$lport]\n";

#accept new connections

my ($rsockaddr, $rport, $rname, @children, $newpid, $conncount);

while ($rsockaddr = accept(CLIENT, SERVER) || die "accept: $!") {
    #set new connection to autoflush
    select(CLIENT);
    $|=1;
    select(STDOUT);
    my ($rport, $raddr) = sockaddr_in($rsockaddr);
    my $rname = gethostbyaddr($raddr, AF_INET);
    #report new connection
    $conncount++;
    print "Accepting connection from ", (defined $rname ? $rname . ' ' : ''), '[', inet_ntoa($raddr), ":$rport]\n";
    #fork a child to handle it
    undef $newpid;
    if (!defined($newpid = fork)) {
	die "fork: $!";
    } elsif ($newpid == 0) {
	print "$conncount: Connection established\n";
	print CLIENT "Request syntax: \"<filename>\" <md5sum> <filesize>\n";
	my $input;
	for (;;) {
	    if (!defined($input = <CLIENT>)) {
		print "$conncount: Client aborted prematurely\n";
		last;
	    }
	    chomp $input;
	    print "$conncount: Request=$input\n";
	    if ($input =~ m/^\s*\"(.*)\"\s*([0-9a-fA-F]+)\s+(\d+)\s*$/) {
		print CLIENT "Request received\n";
		print "$conncount: Request received, filename=\"$1\" md5=\"$2\" size=\"$3\"\n";
	    } else {
		print CLIENT "Invalid request, terminating connection\n";
		print "$conncount: Could not process request!\n";
		last;
	    }
	    my ($request_name, $request_hash, $request_size) = ($1, $2, $3);
	    if (!-e $request_name) {
		print CLIENT "Sorry, I don't have that file\n";
		print "$conncount: Requested file does not exist.\n";
		last;
	    }
	    if (-s $request_name != $request_size) {
		print "$conncount: Requested file size is different\n";
		last;
	    }
	    #my FILE;
	    open(FILE, '<', $request_name) || die "open: $!";
	    my $hasher = Digest::MD5->new;
	    $hasher->add(-s $request_name);
	    $hasher->addfile(*FILE);
	    my $hash = $hasher->hexdigest;
	    print "$conncount: Local file $request_name has hash=$hash\n";
	    undef $hasher;
	    close FILE;
	    if ($hash ne $request_hash) {
		print "$conncount: Request file hash is different\n";
		last;
	    }
	    last;
	}
	close(CLIENT);
	print "$conncount: Closed\n";
	exit 0;
    }
    close(CLIENT);
}

#proof of successful termination

print "Server returned from main.\n";
