#!/usr/bin/env python

import socket
import struct

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, True)
sock.bind(("", 1337))
sock.sendto(repr({"service": 1337}), ("255.255.255.255", 1337))
while True:
    data, addr = sock.recvfrom(0x100)
    print "received from {0}: {1!r}".format(addr, data)
