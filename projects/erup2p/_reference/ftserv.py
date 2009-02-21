#!/bin/env python

import socket
import asyncore
import os
import sys
import gtk

class ReceiveTest(asyncore.dispatcher):
	LINE_TERM = '\r\n'
	file_path = None
	file_obj = None
	file_size = None
	in_buffer = ''
	def log_event(self, info):
		sys.stderr.write(str(self.addr) + ": " + info + "\n")
	def read_line(self):
		try:
			term_pos = self.in_buffer.index(self.LINE_TERM)
		except ValueError:
			return
		rv = self.in_buffer[:term_pos]
		self.in_buffer = self.in_buffer[term_pos + len(self.LINE_TERM) :]
		return rv
	def process_data(self):
		if self.file_path == None:
			line = self.read_line()
			if line:
				self.file_path = line
				self.log_event("file_path = " + line)
			else:
				return
		if self.file_size == None:
			line = self.read_line()
			if line: 
				self.file_size = int(line)
				assert(self.file_size)
				self.log_event("file_size = " + line)
			else:
				return	
		if self.file_obj == None:
			self.file_obj = open(self.file_path, "wb")
		self.file_obj.write(self.in_buffer)
		self.in_buffer = ''
		assert(self.file_obj.tell() <= self.file_size)
		if (self.file_obj.tell() == self.file_size):
			self.close()
			self.log_event("completed file: \"" + self.file_path 
				+ "\" (" + str(self.file_size) + " bytes)")
			return
	def writable(self):
		return False
	def handle_close(self):
		self.log_event("peer closed!")
		self.close()
		if self.file_obj != None:
			assert(self.file_obj.tell() < self.file_size)
			assert(os.path.exists(self.file_path))
			aff = "Destroy uncompleted \"" + self.file_path + "\"?"
			dialog = gtk.MessageDialog(
				type=gtk.MESSAGE_QUESTION,
				buttons=gtk.BUTTONS_YES_NO,
				message_format=aff)
			dialog.connect("response", lambda a,b: a.destroy())
			id = dialog.run()
			#if dialog.run() == gtk.RESPONSE_ACCEPT:
				#self.log_event("should delete file...")
	def handle_read(self):
		self.in_buffer += self.recv(1)
		self.process_data()
	#def __init__(self, channel):
		#asyncore.dispatcher.__init__(self, channel)

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
