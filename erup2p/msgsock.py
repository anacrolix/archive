#!/bin/env python

import socket
import select
import time

socket_map = {}

def poll(timeout, map):

	print "poll(", timeout, map, ")"

	if map is None:
		map = socket_map
	assert map

	r = []; w = []; e = []
	for fd, obj in map.items():
		is_r = obj.readable()
		is_w = obj.writable()
		if is_r:
			r.append(fd)
		if is_w:
			w.append(fd)
		if is_r or is_w:
			e.append(fd)
	if [] == r == w == e:
		time.sleep(timeout)
	else:
		#try:
		r, w, e = select.select(r, w, e, timeout)
		#except select.error, err:
			#if err[0] != EINTR:
				#raise
			#else:
				#return

	for fd in r:
		#obj = map.get(fd)
		#if obj is None:
			#continue
		map[fd].handle_read()
		#read(obj)

	for fd in w:
		#obj = map.get(fd)
		#if obj is None:
			#continue
		#write(obj)
		map[fd].handle_write()

	for fd in e:
		#obj = map.get(fd)
		#if obj is None:
			#continue
		#_exception(obj)
		map[fd].handle_error()

def loop(timeout=1.0, map=None, count=None):

	if map is None:
		map = socket_map

	if count is None:
		while True:
			poll(timeout, map)
	else:
		while count > 0:
			poll(timeout, map)
			count = count - 1

class Socket:
	def __init__(self, map):
		if map is None:
			self._map = socket_map
		else:
			self._map = map
	def map_socket(self):
		assert not self._map.has_key(self._fileno)
		self._map[self._fileno] = self
	def unmap_socket(self):
		del self._map[self._fileno]
		self._fileno = None
	def writable(self):
		raise NotImplementedError
	def readable(self):
		raise NotImplementedError

class EndPoint(Socket):
	connected = False
	def __init__(self, sock=None, map=None, read_cb=None):
		Socket.__init__(self, map)
		if not read_cb is None:
			self.read_cb = read_cb
		if sock is None:
			self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		else:
			self.socket = sock
			self.connected = True
		self._fileno = self.socket.fileno()
		self.map_socket()
	def readable(self):
		return self.connected
	def writable(self):
		#print "EndPoint.writable()"
		return not self.connected
	def send(self, data):
		assert self.socket.send(data) == len(data)
	def handle_read(self):
		print "EndPoint.handle_read(", self.socket.getsockname(), "<-", self.socket.getpeername(), ")"
		data = self.socket.recv(4096)
		assert data > 0
		print data
		return data
	def connect(self, addr):
		print "EndPoint.connect(", addr, ")"
		#self.socket.settimeout(None)
		self.socket.connect(addr)
	def handle_write(self):
		print "EndPoint.handle_write(", self.socket.getsockname(), ")"
		assert self.connected is False
		self.connected = True

class Server(Socket):
	def __init__(self, port=None, iface=None, map=None, accept_cb=None):
		Socket.__init__(self, map)
		if not accept_cb is None:
			self.accept_cb = accept_cb
		self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.set_reuse_addr()
		self._fileno = self.socket.fileno()
		self.map_socket()
		if not port is None:
			if iface is None:
				iface = ''
			self.socket.bind((iface, port))
		else:
			assert iface is None
		assert self.socket.listen(5) is None
	def set_reuse_addr(self):
		print "set_reuse_addr()"
		opt = self.socket.getsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR)
		print "reuseaddr opt is", opt
		opt |= 1
		print "setting reuseaddr opt to", opt
		self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, opt)
	def writable(self):
		return False
	def readable(self):
		return True
	def handle_read(self):
		print "Server.handle_read()"
		sock, addr = self.socket.accept()
		print "received connection from", addr
		self.handle_accept(sock)
	def handle_write(self):
		assert False
	def handle_accept(self, sock):
		try:
			self.accept_cb(sock)
		except TypeError:
			raise NotImplementedError

def accept(sock):
	print sock
	ep = EndPoint(sock)
	ep.send("sup bitch lol")
	#sock.close()

def test():
	print "test()"
	c = EndPoint()
	c.connect(('localhost', 3000))
	s = Server(port=3000, accept_cb=accept)
	#c.send("penis")
	loop(count=3)
	c.send("penis")
	loop()

if __name__ == "__main__":
	print "this is __main__"
	test()

#class Socket:

	#def __init__(self, sock=None, map=None):
		#print "Client.__init__()"

		#assert map is None
		#if map is None:
			#self._map = socket_map
		#else:
			#self._map = map

		#if sock is None:
			#"creating new socket"
			#self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		#else:
			#"using existing socket"
			#self.socket = sock
		#self._fileno = self.socket.fileno()
		#print "new socket has fd:", self._fileno
		#self.add_channel()

	#def add_channel(self):
		#print "Client.add_channel()"
		#assert not self._map.has_key(self._fileno)
		#self._map[self._fileno] = self

	#def del_channel(self):
		#print "Client.del_channel()"
		#del self._map[self._fileno]
		#self._fileno = None

	#def connect(self, address):
		#self.socket.connect(address)
        ## XXX Should interpret Winsock return values
        ##if err in (EINPROGRESS, EALREADY, EWOULDBLOCK):
            ##return
        ##if err in (0, EISCONN):
            ##self.addr = address
            ##self.connected = True
            ##self.handle_connect()
        ##else:
            ##raise socket.error, (err, errorcode[err])

	#def listen(self, backlog=5):
		#return self.socket.listen(backlog)

	#def accept(self):
		## XXX can return either an address pair or None
		##try:
		#conn, addr = self.socket.accept()
		#return conn, addr
		##except socket.error, why:
			##if why[0] == EWOULDBLOCK:
				##pass
			##else:
				##raise

	#def readable(self):
		#return True

	#def writable(self):
		#return True

	#def handle_read(self):
		#raise NotImplementedError
