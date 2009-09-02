#!/usr/bin/env python

import socket
import sys
import zlib

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], int(sys.argv[2])))
f = open(sys.argv[3], "rb")
z = zlib.compressobj(9)
while True:
    b = f.read(1)
    if b:
        p = z.compress(b)
    else:
        p = z.flush()
    assert None == s.sendall(p)
    if not b: break
