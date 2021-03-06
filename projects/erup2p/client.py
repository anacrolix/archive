#!/bin/env python

# TODO

# set default focus on message_te in PeerFrame
# popup dialog asking if you want all chats closed on shutdown
# status bar declaring connection status

import wx
import os
import sys
import socket
from network import AsyncSockThread, MessageDispatcher as ServerHandler
import threading

VERSION = '0.0.1-alpha'
APP_NAME = 'Eru P2P'
WEBSITE_URL = 'http://stupidape.dyndns.org'
DEVELOPERS = ('Eruanno <stupidape@hotmail.com>',)
DESCRIPTION = \
"""A simple Instant Messenger intended to provided reliable and simple chat and peer to peer file transfers."""

def log(*info):

	for i in info: print i,
	print

server_event = threading.Event()
server_event.set()

def funcyou():
	print "setting server event"
	server_event.set()

#class PeerFileDropTarget(wx.FileDropTarget):

	#pass

class PeerFrame(wx.Frame):

	destroy_on_close = False

	def __init__(self, event_cb):

		wx.Frame.__init__(self, None)
		self.event_cb = event_cb

		self.Bind(wx.EVT_CLOSE, self.on_close)
		self.Bind(wx.EVT_TEXT_ENTER, self.on_enter)

		self.history_te = wx.TextCtrl(self,
			style=wx.TE_MULTILINE|wx.TE_AUTO_URL|wx.TE_READONLY)

		self.message_te = wx.TextCtrl(self, style=wx.TE_PROCESS_ENTER)

		bs = wx.BoxSizer(wx.VERTICAL)
		bs.Add(self.history_te, 1, wx.EXPAND)
		bs.Add(self.message_te, 0, wx.EXPAND)
		self.SetSizer(bs)

	def notify(self, message, *data):

		self.event_cb(self, message, *data)

	def on_enter(self, event):

		msg_str = self.message_te.GetValue()
		print msg_str
		self.message_te.Clear()
		self.notify('enter_message', msg_str)

	def add_history_message(self, speaker, message): # inbound?

		s = speaker + ": " + message
		if not self.history_te.IsEmpty():
			s = '\n' + s
		self.history_te.AppendText(s)

	def on_close(self, event):

		if self.destroy_on_close:
			self.Destroy()
		else:
			self.Show(False)

class PeerList(dict):

	class Peer(object):

		def __init__(self,  event_cb, ident):

			self.ident = ident
			self.event_cb = event_cb
			self.name = ":".join(map(lambda p: str(p), ident))
			self.frame = PeerFrame(self.handle_peerframe)
			self.update_frame_title()

		def update_frame_title(self, title=None):

			assert title == None # who are you and why teh fuck u usnig this?
			if title == None:
				title = " ".join((self.name, "-", ":".join(map(lambda p: str(p), self.ident))))
			self.frame.SetTitle(title)

		def handle_peerframe(self, caller, event, *data):

			print "handle_peerframe(", caller
			assert caller == self.frame
			self.event_cb(self, event, *data)

		#def __del__(self):

			#print "wtf some faggot deleted me"
			#self.frame.Destroy()

	def __init__(self, event_cb):

		self.event_cb = event_cb

	def login(self, ident):

		if self.has_key(ident):
			print "login(", ident, ")", "is already logged in!"
		self[ident] = self.Peer(self.event_cb, ident)

	def close(self, ident, force=False):

		assert self.has_key(ident)
		if force or not self[ident].frame.IsShown():
			self[ident].frame.Destroy()
		else:
			self[ident].frame.destroy_on_close = True
		del self[ident]

	def closeall(self, force=False):

		for a in self.keys():
			self.close(a, force)

	def __del__(self):

		print "PeerList.__del__"
		keys = self.keys()
		for key in keys: self.close(key)

class MainFrame(wx.Frame):

	def __init__(self, notify_cb):

		wx.Frame.__init__(self, None, title='Eru P2P', size=(200, 400))
		self.notify_cb = notify_cb

		# custom close event
		self.Bind(wx.EVT_CLOSE, self.on_close)

		self.peer_listbox = wx.ListBox(self)
		self.peer_listbox.Bind(wx.EVT_LEFT_DCLICK, self.on_dclick_peers)

		# mb = menubar, m = menu, mi = menuitem
		mb = wx.MenuBar()
		m = wx.Menu()
		mi = m.Append(-1, text='&Connect')
		self.Bind(wx.EVT_MENU, self.on_connect, mi)
		mi = m.Append(-1, text='Set &Name...')
		self.Bind(wx.EVT_MENU, self.on_setname, mi)
		m.AppendSeparator()
		mi = m.Append(-1, text='&Quit')
		self.Bind(wx.EVT_MENU, self.on_quit, mi)
		mb.Append(m, '&Server')
		m = wx.Menu()
		mi = m.Append(-1, '&About')
		self.Bind(wx.EVT_MENU, self.on_about, mi)
		mb.Append(m, '&Help')
		self.SetMenuBar(mb)

	def notify(self, *data):

		self.notify_cb(self, *data)

	def on_connect(self, event):

		print "MainFrame:on_connect"
		self.notify('connect')

	def on_about(self, event):

		info = wx.AboutDialogInfo()
		info.SetName(APP_NAME)
		info.SetVersion(VERSION)
		info.SetDescription(DESCRIPTION)
		#info.SetCopyright('None!')
		info.SetWebSite(WEBSITE_URL)
		for dev in DEVELOPERS:
			info.AddDeveloper(dev)

		wx.AboutBox(info)

	def on_close(self, event):

		print "yo close me faggot lulz"
		self.notify('close')

	def on_quit(self, event):

		self.Close()
		#self.Destroy()

	def on_setname(self, event):

		self.notify('setname')

	def on_dclick_peers(self, event):

		i = self.peer_listbox.HitTest(event.GetPosition())
		print "left double clicked on", i
		if i < 0: return
		assert i < self.peer_listbox.GetCount()
		ident = self.peer_listbox.GetClientData(i)
		assert ident
		self.notify('openchat', ident)

	def get_peer_index(self, peer):

		for i in range(self.peer_listbox.GetCount()):
			if self.peer_listbox.GetClientData(i) == peer.ident:
				return i
		else:
			return -1

	def peer_login(self, peer):

		assert self.get_peer_index(peer) < 0
		self.peer_listbox.Append(peer.name, peer.ident)

	def peer_setname(self, peer):

		self.peer_listbox.SetString(self.get_peer_index(peer), peer.name)

	def peer_close(self, peer):

		self.peer_listbox.Delete(self.get_peer_index(peer))

	def peer_closeall(self):

		self.peer_listbox.Clear()

class ClientApp(wx.App):

	# both the below vars need to be saved and loaded from a log file...

	# need to test this on windows
	user_name = os.environ['LOGNAME']
	# need to provide a dialog to change this
	server_addr = ('stupidape.dyndns.org', 3000)

	def OnInit(self):
		"""Corresponds to OnExit()"""

		self.main_frame = MainFrame(self.handle_mainframe)
		self.SetTopWindow(self.main_frame)
		self.main_frame.Show()

		self.reset_peers()

		self.sock_thread = AsyncSockThread()
		self.sock_thread.start()

		self.server_handler = ServerHandler(self.handle_server_event)

		return True

	def OnExit(self):
		"""This seems to get called after all frames have died."""

		print "Closing sockets..."
		self.sock_thread.stop()
		self.server_handler.close()
		self.sock_thread.join()

	def reset_peers(self):

		self.peers = PeerList(self.handle_peerframe_event)
		self.main_frame.peer_closeall()

	def handle_mainframe(self, caller, event, *args):
		# event is not to be confused with a wx event...
		assert caller == self.main_frame
		getattr(self, 'user_' + event)(*args)

	def user_connect(self):

		self.reset_peers()
		self.server_handler.connect(self.server_addr)

	def user_setname(self):

		print "settnig name!"
		ted = wx.TextEntryDialog(self.main_frame, 'As whom do you wish to be known?', defaultValue=self.user_name)
		if ted.ShowModal() == wx.ID_OK:
			self.user_name = ted.GetValue()
			self.server_handler.send('setname', self.user_name)

	def user_close(self):

		self.main_frame.Destroy()
		self.peers.closeall(True)
		for a in self.peers.keys():
			self.peers.close(a, True)
		#del self.peers

	def user_openchat(self, ident):

		self.peers[ident].frame.Show(True)

	# SERVER CALLBACKS



	def handle_server_event(self, source, event, *data):

		#wx.CallAfter(getattr(self, attrfunc), *args)
		print "handle_server_event(", event, data, ")"
		#log(event, data)
		wx.CallAfter(getattr(self, 'server_cb_' + event), *data)
		#assert server_event.isSet()
		#server_event.clear()
		a = threading.Event()
		assert not a.isSet()
		print "cleared server event"
		wx.CallAfter(lambda a: a.set(), a)
		#wx.GetApp().ProcessPendingEvents()
		print "waiting on server event"
		a.wait()
		print "server event completed"

	def server_cb_connected(self):

		try:
			self.server_handler.send('login')
			self.server_handler.send('setname', self.user_name)
		except socket.error, wtf:
			print "Failed to login! Did you reconnect too quickly?", wtf[1]

	def server_cb_login(self, ident):

		self.peers.login(ident)
		self.main_frame.peer_login(self.peers[ident])
		#self.main_frame.login(self.peers[ident])

	def server_cb_setname(self, ident, name):

		self.peers[ident].name = name
		self.peers[ident].update_frame_title()
		self.main_frame.peer_setname(self.peers[ident])

	def server_cb_error(self, errstr):

		print "server_error", errstr

	def server_cb_close(self, ident=None):

		print "server_cb_close(", ident, ")"
		if ident == None:
			#try:
			#if self.server_handler.connecting:
			#	return
			#except AttributeError, wtf:
				#print wtf
				#sys.exit(0)
			#self.server_handler.close()
			self.main_frame.peer_closeall()
			self.peers.closeall()
		else:
			try:
				self.main_frame.peer_close(self.peers[ident])
				self.peers.close(ident)
			except KeyError:
				print "No matching peer:", ident

	def server_cb_message(self, ident, message):

		print "server_cb_message(", ident, message, ")"
		self.peers[ident].frame.add_history_message(self.peers[ident].name, message)
		self.peers[ident].frame.Show(True)
		self.peers[ident].frame.RequestUserAttention()

	def server_cb_msg_ack(self, ident, message):

		print "server_cb_msg_ack(", ident, message, ")"
		self.peers[ident].frame.add_history_message(self.user_name, message)

	# PEER FRAME CALLBACKS

	def handle_peerframe_event(self, peer, event, *data):

		getattr(self, 'peerframe_cb_' + event)(peer, *data)

	def peerframe_cb_enter_message(self, peer, message):

		print "peerframe_cb_enter_message(", peer.ident, message, ")"
		if self.peers.has_key(peer.ident):
			self.server_handler.send('message', peer.ident, message)
		else:
			peer.frame.add_history_message('Error', 'Recipient not available!')

def main():

	app = ClientApp()
	app.MainLoop()

if __name__ == '__main__':

	main()
