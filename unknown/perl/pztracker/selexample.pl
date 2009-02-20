#!/usr/bin/perl

use IO::Socket;
$SERVER_PORT = 63000;

$lsn = new IO::Socket::INET(Listen => SOMAXCONN, LocalPort => $SERVER_PORT);

while(@ready = $sel->can_read) {
    foreach $fh (@ready) {
        if($fh == $lsn) {
            # Create a new socket
            $new = $lsn->accept;
            $sel->add($new);
        }
        else {
            # Process socket

            # Maybe we have finished with the socket
            $sel->remove($fh);
            $fh->close;
        }
    }
}