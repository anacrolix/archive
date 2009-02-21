#!/bin/env python

import socket
import select
import time
import errno

socket_map = {}

def poll(timeout):

	print "poll(", timeout, ")"

	print socket_map
	r = []; w = []; e = []
	for fd, obj in socket_map.items():
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
		if timeout is None:
			r, w, e = select.select(r, w, e)
		else:
			r, w, e = select.select(r, w, e, timeout)
	for fd in r:
		socket_map[fd].read_event()
	for fd in w:
		socket_map[fd].write_event()
	for fd in e:
		socket_map[fd].expt_event()

def loop(timeout=None, count=None):

	if count is None:
		while True:
			poll(timeout)
	else:
		while count > 0:
			poll(timeout)
			count = count - 1

class Socket:
	def __init__(self): pass
	def add_to_map(self):
		assert not socket_map.has_key(self._fileno)
		socket_map[self._fileno] = self
	def del_from_map(self):
		del socket_map[self._fileno]
		self._fileno = None
	def writable(self):
		raise NotImplementedError
	def readable(self):
		raise NotImplementedError

class EndPoint(Socket):
	maxread = 0x1000
	connected = False
	def __init__(self, sockobj=None):
		Socket.__init__(self)
		if sockobj is None:
			self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		else:
			self.socket = sockobj
			self.connected = True
		self._fileno = self.socket.fileno()
		self.add_to_map()
	def readable(self):
		# readable when connected
		return self.connected
	def writable(self):
		# writable on asynchronous connection event
		return not self.connected
	def read_event(self):
		print "EndPoint.read_event(", self, ")"
		data = self.socket.recv(self.maxread)
		if not data:
			self.close_event()
		else:
			self.handle_read(data)
	def write_event(self):
		print "EndPoint.write_event(", self, ")"
		if not self.connected:
			self.connect_event()
		else:
			self.handle_write()
	def connect_event(self):
		print "connect_event()"
		errval = self.socket.getsockopt(socket.SOL_SOCKET, socket.SO_ERROR)
		if errval is 0:
			print "connection accepted"
			self.connected = True
			self.handle_connect()
		else:
			raise socket.error, (errval, errno.errorcode[errval])
			self.handle_refused((errval, errno.errorcode[errval]))
	def close_event(self):
		self.del_from_map()
		self.socket.close()
		self.handle_close()
	def send(self, data):
		assert self.socket.send(data) == len(data)
	def handle_read(self, data):
		print "EndPoint.handle_read(", self.socket.getsockname(), "<-", self.socket.getpeername(), ")"
		print data
	def connect(self, addr, timeout=None):
		print "EndPoint.connect(", addr, ")"
		#self.socket.settimeout(None)
		self.socket.settimeout(timeout)
		try:
			self.socket.connect(addr)
		except socket.error, err:
			if timeout is not None and err[0] in (errno.EINPROGRESS,):
				return
			else:
				raise
	def handle_write(self):
		print "EndPoint.handle_write(", self.socket.getsockname(), ")"
		assert self.connected is False
		err = self.socket.getsockopt(socket.SOL_SOCKET, socket.SO_ERROR)
		print (err, errno.errorcode[err])
		self.connected = True
	def handle_close(self):
		print "MyEndPoint.handle_close(", self, ")"
		print "that's nice i closed, who cares?"

class Server(Socket):
	backlog = 5
	def __init__(self, port=None):
		# does nothing
		Socket.__init__(self)
		self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.set_reuse_addr()
		self._fileno = self.socket.fileno()
		self.add_to_map()
		if port is not None:
			# all interfaces
			self.socket.bind(('', port))
		# not sure what else it can return...
		assert self.socket.listen(self.backlog) is None
	def set_reuse_addr(self):
		"""Set the first bit flag true on the reuse address socket flags"""
		print "Server.set_reuse_addr(", self, ")"
		opt = self.socket.getsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR)
		print "setting reuseaddr opt from", opt,
		opt |= 1
		print "to", opt
		self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, opt)
	def writable(self):
		# listening sockets are not writable
		return False
	def readable(self):
		# readable on every connection attempts
		return True
	def read_event(self):
		print "Server.read_event(", self, ")"
		sock, addr = self.socket.accept()
		print "received connection from", addr
		self.handle_accept(EndPoint(sock))
	def handle_read(self):
		print "Server.handle_read()"
		sock, addr = self.socket.accept()
		print "received connection from", addr
		self.handle_accept(sock)
	def handle_accept(self, endpoint):
		raise NotImplementedError

def accept(sock):
	print sock
	ep = EndPoint(sock)
	ep.send("sup bitch lol")
	#sock.close()

def test():
	class MyServer(Server):
		def handle_accept(self, endpoint):
			pass
	class MyEndPoint(EndPoint):
		def handle_connect(self):
			print "MyEndPoint.handle_connect(", self, ")"
		def handle_close(self):
			print "MyEndPoint.handle_close(", self, ")"
	print "test()"
	c = MyEndPoint()
	s = MyServer(port=3000)
	c.connect(('localhost', 3000))
	time.sleep(2.0)
	c.send("penis")
	loop(count=3)
	c.send("penis")
	loop()

if __name__ == "__main__":
	print "this is __main__"
	test()
