#!/bin/env python

import asyncore
import socket
#import pickle

class PeerHandler(asyncore.dispatcher):
	peer_name = None
	sock_buffer = ''
	got_list = False
	LINE_TERM = '\r\n'

	def read_line(self):
		try:
			term_pos = self.sock_buffer.index(self.LINE_TERM)
		except ValueError:
			return None
		rv = self.sock_buffer[:term_pos]
		self.sock_buffer = \
			self.sock_buffer[term_pos + len(self.LINE_TERM):]
		return rv
		
	def handle_connect(self):
		self.master.peercb_getlist(self)

	def process_data(self):
		if not self.peer_name:
			self.peer_name = self.read_line()
			if self.peer_name:
				print "Peer name:", self.peer_name
				self.master.peercb_gotname(self)
				self.master.peercb_getlist(self)
			return
		print "Received unexpected data!"
	
	def handle_write(self):
		self.master.peercb_getlist(self)
		self.got_list = True
				
	def writable(self):
		#return not self.got_list
		return False

	def handle_close(self):
		self.master.peercb_closing(self)
		self.close()

	def handle_read(self):
		self.sock_buffer += self.recv(1)
		if len(self.sock_buffer) > 0:
			self.process_data()

	def __init__(self, channel, master):
		asyncore.dispatcher.__init__(self, channel)
		self.master = master

class PeerServer(asyncore.dispatcher):
	peers = []
	def __init__(self, port, host=''):
		asyncore.dispatcher.__init__(self)
		self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
		self.bind((host, port))
		self.listen(socket.SOMAXCONN)
	def peercb_gotname(self, peer_obj):
		for peer in self.peers:
			if peer == peer_obj: continue
			peer.send("\r\n".join(["connected", peer_obj.peer_name, peer_obj.addr[0], str(peer_obj.addr[1]), '']))
	def peercb_closing(self, peer_obj):
		self.peers.remove(peer_obj)
		for p in self.peers:
			p.send("\r\n".join(["disconnected", peer_obj.addr[0], str(peer_obj.addr[1]), '']))
	def peercb_getlist(self, peer_obj):
		for a in self.peers:
			if a == peer_obj: continue
			peer_obj.send("\r\n".join(["connected", a.peer_name, a.addr[0], str(a.addr[1]), '']))
	def handle_accept(self):
		channel, addr = self.accept()
		new_peer = PeerHandler(channel, self)
		print "Accepted:", new_peer.addr
		self.peers.append(new_peer)
		#for peer_obj in self.peers:
			#new_peer.send("\r\n".join(["connected", peer_obj.peer_name, peer_obj.addr[0], str(peer_obj.addr[1]), '']))

def main():
	PeerServer(port=3000)
	asyncore.loop()

if __name__ == "__main__":
	main()
