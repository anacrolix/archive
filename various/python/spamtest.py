import socket
import sys

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
if sys.argv[1] == "receive":
    s.bind(('', 1337))
    s.listen(socket.SOMAXCONN)
    while True:
        t = s.accept()[0]
        while True:
            assert t.recv(1)
elif sys.argv[1] == "send":
    s.connect(("localhost", 1337))
    while True:
        s.settimeout(0.0)
        s.send("spam\n")
