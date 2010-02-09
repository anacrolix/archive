import socket
import time

a = socket.socket()
a.bind(("localhost", 0))
servaddr = a.getsockname()
a.listen(1)

b = socket.socket()
b.connect(servaddr)

c = a.accept()[0]

while True:
    c.send("\xf00" * 1024)
    b.recv(0x1000)
    time.sleep(1.0)
