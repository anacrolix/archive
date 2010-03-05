#!/usr/bin/env python

import socket

a = socket.socket()
a.bind(('', 3000))
a.listen(1)
while True:
    b = a.accept()[0]
    while True:
        print repr(b.recv(0x1000))
