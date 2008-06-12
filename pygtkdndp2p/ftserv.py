#!/bin/env python

import socket, asyncore, os

class ReceiveTest(asyncore.dispatcher):
	path = None
	file_length = None
	in_buffer = str()
	def process_data(self):
		if self.path == None:
			try: term_pos = self.in_buffer.index('\r\n')
			except ValueError: return
			self.path = self.in_buffer[:term_pos]
			print "Path is", self.path
			self.in_buffer = self.in_buffer[term_pos+2:]
		elif self.file_length == None:
			try: term_pos = self.in_buffer.index('\r\n')
			except ValueError: return
			self.file_length = int(self.in_buffer[:term_pos])
			print "File length is", self.file_length
			self.in_buffer = self.in_buffer[term_pos+2:]
		elif len(self.in_buffer) >= self.file_length:
			print "File \"", self.path, "\"received."
			print len(self.in_buffer)
			assert(len(self.in_buffer) == self.file_length)
			#assert(not os.path.exists(self.path))
			open(self.path, 'wb').write(self.in_buffer)
			self.close()
			print "Received:", self.path
			return
		if (self.path == None or self.file_length == None) and len(self.in_buffer) > 0:
			self.process_data()
	def writable(self):
		return False
	def handle_close(self):
		self.close()
	def handle_read(self):
		self.in_buffer += self.recv(1)
		self.process_data()

class ListenTest(asyncore.dispatcher):
	def __init__(self, port, host=''):
		asyncore.dispatcher.__init__(self)
		self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
		self.bind((host, port))
		self.listen(socket.SOMAXCONN)
	def handle_accept(self):
		channel, remote_addr = self.accept()
		print "Accepted connection from:", remote_addr
		ReceiveTest(channel)
	
def main():
	ListenTest(3000)
	asyncore.loop()

if __name__ == "__main__":
	main()
