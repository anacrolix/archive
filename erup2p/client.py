#!/bin/env python

import wx
import threading
import asyncore, asynchat
import socket
import os
import time

LINE_TERM = '\r\n'
VERSION = '0.0.1-alpha'
APP_NAME = 'Eru P2P'
WEBSITE_URL = 'http://stupidape.dyndns.org'
DEVELOPERS = ('Eruanno',)
DESCRIPTION = \
"""A simple Instant Messenger intended to provided reliable and simple chat and peer to peer file transfers."""

def log(*info):

	for i in info: print i,
	print

class ServerHandler():
	
	class ServerDispatcher(asynchat.async_chat):
		
		def notify(self, event, *args):
			
			self.notify_cb(self, event, *args)
		
		def __init__(self, notify_cb):
			
			asynchat.async_chat.__init__(self)
			self.notify_cb = notify_cb
			self.buffer = ''
			self.set_terminator(LINE_TERM)
			
		def collect_incoming_data(self, data):
			
			self.buffer += data
		
		def found_terminator(self):
			
			message = eval(self.buffer)
			self.buffer = ''
			assert len(message) == 2
			self.notify(message[0], *message[1])
						
		def handle_connect(self):
			
			self.notify("connected")
	
	def send(self, header, *data):
		
		if not self.dispatcher: return False
		try:
			self.dispatcher.send(repr((header, data)) + LINE_TERM)
		except socket.error, str:
			print str
			self.notify_cb("error", str)
			return False
		return True
	
	def __init__(self, notify_cb):
		
		self.notify_cb = notify_cb
		self.dispatcher = None

	def handle_dispatcher(self, caller, event, *args):
		
		assert caller == self.dispatcher
		self.notify_cb(event, *args)

	def connect(self, address):
		
		try: self.dispatcher.close()
		except AttributeError: pass
		self.dispatcher = self.ServerDispatcher(self.handle_dispatcher)
		self.dispatcher.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.dispatcher.connect(address)
	
	def close(self):
		
		try:
			if self.dispatcher:
				self.dispatcher.close()
		except AttributeError:
			print "lulz you never created a server dispatcher"

class AsyncSockThread(threading.Thread):

	quit = False
	
	def __init__(self, timeout=1.0):
		
		threading.Thread.__init__(self)
		self.timeout = timeout
	
	def run(self):
		
		while True:
			asyncore.loop(timeout=self.timeout)
			print "asyncore: No sockets"
			if self.quit: break
			time.sleep(self.timeout)
	
	def stop(self):
		
		self.quit = True

class PeerFileDropTarget(wx.FileDropTarget):
	
	pass

class PeerFrame(wx.Frame):
	
	def __init__(self, event_cb):
		
		wx.Frame.__init__(self, None)
		self.event_cb = event_cb
		
		self.Bind(wx.EVT_CLOSE, self.on_close)	
		self.Bind(wx.EVT_TEXT_ENTER, self.on_enter)	
		
		self.history_te = wx.TextCtrl(self, value="history", style=wx.TE_MULTILINE|wx.TE_AUTO_URL|wx.TE_READONLY)
		
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
		print "STUB"
		self.notify('message', msg_str)
		
	def on_close(self, event):
		
		self.Show(False)

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
	
class PeerList(dict):
	
	class Peer():
		
		def __init__(self, ident):
			
			self.ident = ident
			self.name = ":".join(map(lambda p: str(p), ident))
			self.frame = PeerFrame(self.handle_peerframe)
			self.update_frame_title()
			
		def update_frame_title(self, title=None):
			
			assert title == None # who are you and why teh fuck u usnig this?
			if title == None:
				title = " ".join((self.name, "-", ":".join(map(lambda p: str(p), self.ident))))
			self.frame.SetTitle(title)
			
		def handle_peerframe(self, caller, event, *data):	
		
			pass
		
		#def __del__(self):
			
			#print "wtf some faggot deleted me"
			#self.frame.Destroy()		
	
	def login(self, ident):
		
		assert not self.has_key(ident)
		self[ident] = self.Peer(ident)
	
	def close(self, ident):
		
		assert self.has_key(ident)
		self[ident].frame.Destroy()
		del self[ident]
		
	def __del__(self):
		
		print "PeerList.__del__"
		keys = self.keys()
		for key in keys: self.close(key)

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
		
		self.server_handler = ServerHandler(self.handle_server)
		
		return True
		
	def OnExit(self):
		"""This seems to get called after all frames have died."""
		print "Closing sockets..."
		self.sock_thread.stop()
		self.server_handler.close()
		self.sock_thread.join()
	
	def reset_peers(self):
		
		self.peers = PeerList()
		self.main_frame.peer_closeall()
				
	def handle_server(self, event, *data):
		
		#wx.CallAfter(getattr(self, attrfunc), *args)
		log(event, data)
		wx.CallAfter(getattr(self, 'server_' + event), *data)
		
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
		for a in self.peers.keys():
			self.peers.close(a)
		#del self.peers
		
	def user_openchat(self, ident):
		
		self.peers[ident].frame.Show(True)
		
	def server_connected(self):
		
		self.server_handler.send('login') and \
		self.server_handler.send('setname', self.user_name)
		
	def server_login(self, ident):
		
		self.peers.login(ident)
		self.main_frame.peer_login(self.peers[ident])
		#self.main_frame.login(self.peers[ident])
		
	def server_setname(self, ident, name):
		
		self.peers[ident].name = name
		self.peers[ident].update_frame_title()
		self.main_frame.peer_setname(self.peers[ident])
		
	def server_error(self, errstr):
		
		print "server_error", errstr
		
	def server_close(self, ident):
		
		try:
			self.main_frame.peer_close(self.peers[ident])
			self.peers.close(ident)
		except KeyError:
			print "No matching peer:", ident
	
def main():
	
	app = ClientApp()
	app.MainLoop()
	
if __name__ == '__main__':
	
	main()
