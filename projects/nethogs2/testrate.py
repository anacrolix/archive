import socket
import time

a = socket.socket()
a.bind(("localhost", 0))
servaddr = a.getsockname()
a.listen(1)

b = socket.socket()
b.connect(servaddr)

unknownSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
print "sending UDP from", unknownSocket.getsockname()

c = a.accept()[0]

while True:
    c.send("\x00" * 1024)
    b.recv(0x1000)
    unknownSocket.sendto("\x00" * 1024, ("localhost", 3000))
    time.sleep(1.0)
