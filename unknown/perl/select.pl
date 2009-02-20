#!/usr/bin/perl -w


use IO::Socket::INET;
use IO::Select;


$server = IO::Socket::INET->new(Listen => SOMAXCONN,
	LocalPort => 3000,
    Proto => 'tcp',
    Reuse => 1);

$select = IO::Select->new($server);

while (@ready = $select->can_read) {
	foreach $fh (@ready) {
    	if ($fh == $server) {

while ($client = $server->accept()) {
	print $client "sup bitch\n";
    close $client;
}

#ONE WAY PIPES

#    use IO::Handle; # thousands of lines just for autoflush :-(
#    use Socket;
#    pipe PARENT_RDR, CHILD_WTR or die "$!";
#    CHILD_WTR->autoflush(1);
#        if ($pid = fork) {
#    close PARENT_RDR;# close PARENT_WTR;
#    for (my $count=1;;$count++) {print CHILD_WTR "This could be a death $count\015\012"; sleep(1); }
#    close CHILD_WTR;
#    waitpid($pid,0);
#    } else {
#    die "cannot fork: $!" unless defined $pid;
#    close CHILD_WTR;
#    socket(SOCK_SERVER, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
#    setsockopt(SOCK_SERVER, SOL_SOCKET, SO_REUSEADDR, pack("l", 1));
#    bind(SOCK_SERVER, sockaddr_in(3000, INADDR_ANY));
#    listen(SOCK_SERVER, SOMAXCONN);
#    for (;accept(SOCK_CLIENT, SOCK_SERVER); close SOCK_CLIENT) {
#       if (not fork) {
#
#         send SOCK_CLIENT, $_, 0 while <PARENT_RDR>;
#         exit;
#       }
#    }
#
#
#    close PARENT_RDR; #close PARENT_WTR;
#    exit;
#    }