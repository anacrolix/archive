#!/bin/env python

import asyncore
import socket
#import pickle
from network import MessageDispatcher as PeerDispatcher
import pdb

class Peer():

	def log(self, *info):

		print self.name + ":",
		for i in info: print i,
		print

	def send(self, header, *data):

		self.dispatcher.send(header, *data)
		#self.dispatcher.send(repr((header, data)) + LINE_TERM)

	def __init__(self, dispatcher):

		self.dispatcher = dispatcher
		self.name = ":".join(map(lambda i: str(i), self.dispatcher.addr))
		self.ident = self.dispatcher.addr

class PeerServer(asyncore.dispatcher):

	#peers = {} # {dispatcher.addr : Peer}

	def __init__(self):

		asyncore.dispatcher.__init__(self)
		self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
		self.bind(('', 3000))
		self.listen(socket.SOMAXCONN)
		self.peers = {}

	def log(self, info):

		print info

	# PEER DISPATCHER CALLBACKS

	def handle_dispatcher(self, dispatcher, header, *data):

		print dispatcher
		print header
		print data
		peer = self.peers[dispatcher.addr]
		peer.log(header, data)
		getattr(self, 'peer_cb_' + header)(peer, *data)

	def peer_cb_login(self, peer):

		for other in self.peers.values():
			if peer == other: continue
			other.send('login', peer.ident)
			peer.send('login', other.ident)
			peer.send('setname', other.ident, other.name)

	def peer_cb_setname(self, peer, name):

		peer.name = name
		for other in self.peers.values():
			if peer == other: continue
			other.send('setname', peer.ident, peer.name)

	def peer_cb_close(self, peer):

		print "peer_cb_close(", peer.ident, ")"
		peer.dispatcher.close()
		del self.peers[peer.ident]
		for other in self.peers.values():
			assert not peer == other
			assert not peer.ident == other.ident
			other.send('close', peer.ident)

	def peer_cb_message(self, peer, ident, message):

		print "peer_cb_message()", peer.name, "->", self.peers[ident].name, message
		self.peers[ident].send('message', peer.ident, message)
		peer.send('msg_ack', ident, message)

	# SUP BITCHES

	def handle_accept(self):

		channel, addr = self.accept()
		new_handler = PeerDispatcher(self.handle_dispatcher, channel)
		assert addr == new_handler.addr
		assert not self.peers.has_key(addr)
		self.peers[addr] = Peer(new_handler)
		assert addr == self.peers[addr].dispatcher.addr

def main():

	PeerServer()
	asyncore.loop()

if __name__ == "__main__":

	main()
