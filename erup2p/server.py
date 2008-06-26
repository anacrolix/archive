#!/bin/env python

import asyncore, asynchat
import socket
#import pickle

LINE_TERM = '\r\n'

class PeerDispatcher(asynchat.async_chat):
		
	def handle_close(self):		
		
		self.notify('close')
	
	def notify(self, header, *data):
		
		self.notify_cb(self, header, *data)
			
	def found_terminator(self):
		
		message = eval(self.buffer)
		self.buffer = ''
		self.log(message)
		assert len(message) == 2
		self.notify(message[0], *message[1])		
	
	def collect_incoming_data(self, data):
		
		self.buffer += data
		
	def log(self, *info):
		
		print str(self.addr) + ":",
		for i in info: print i,
		print

	def __init__(self, channel, notify_cb):
		
		asynchat.async_chat.__init__(self, channel)
		self.set_terminator(LINE_TERM)
		self.notify_cb = notify_cb
		self.buffer = ''

class Peer():
	
	def send(self, header, *data):
		
		self.dispatcher.send(repr((header, data)) + LINE_TERM)
	
	def __init__(self, dispatcher):
		
		self.dispatcher = dispatcher
		self.name = ":".join(map(lambda i: str(i), self.dispatcher.addr))
		self.ident = self.dispatcher.addr

class PeerServer(asyncore.dispatcher):
	
	peers = {}
	
	def on_dispatcher_notify(self, dispatcher, header, *data):
		
		peer = self.peers[dispatcher.addr]
		getattr(self, 'peercb_' + header)(peer, *data)
	
	def __init__(self):
		
		asyncore.dispatcher.__init__(self)
		self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
		self.bind(('', 3000))
		self.listen(socket.SOMAXCONN)
			
	def log(self, info):
		
		print info
		
	def peercb_login(self, peer):
		
		for other in self.peers.values():
			if peer == other: continue
			other.send('login', peer.ident)
			peer.send('login', other.ident)
			peer.send('setname', other.ident, other.name)
	
	def peercb_setname(self, peer, name):
		
		peer.name = name
		for other in self.peers.values():
			if peer == other: continue
			other.send('setname', peer.ident, peer.name)
			
	def peercb_close(self, peer):
		
		peer.dispatcher.close()
		del self.peers[peer.ident]
		for other in self.peers.values():
			other.send('close', peer.ident)
			
	def handle_accept(self):
		
		channel, addr = self.accept()
		new_handler = PeerDispatcher(channel, self.on_dispatcher_notify)
		assert addr == new_handler.addr
		assert not self.peers.has_key(addr)
		self.peers[addr] = Peer(new_handler)
		assert addr == self.peers[addr].dispatcher.addr

def main():
	
	PeerServer()
	asyncore.loop()

if __name__ == "__main__":
	
	main()
