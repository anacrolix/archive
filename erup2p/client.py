#!/bin/env python

import wx
import threading
import asyncore, asynchat
import socket
import os
import time

LINE_TERM = '\r\n'

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
		
		self.dispatcher.send(repr((header, data)) + LINE_TERM)
	
	def __init__(self, notify_cb):
		
		self.notify_cb = notify_cb
		#dispatcher = None

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
		
		if self.dispatcher:
			self.dispatcher.close()

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
	
	pass

class MainFrame(wx.Frame):
	
	def __init__(self, notify_cb):
		
		wx.Frame.__init__(self, None, title='Eru P2P')
		self.notify_cb = notify_cb
		
		lb = wx.ListBox(self)
		lb.Append('wank stick')
		
		# mb = menubar, m = menu, mi = menuitem
		mb = wx.MenuBar()
		m = wx.Menu()
		mi = m.Append(-1, text='&Connect')
		self.Bind(wx.EVT_MENU, self.on_connect, mi)
		m.AppendSeparator()
		mi = m.Append(-1, text='&Quit')
		self.Bind(wx.EVT_MENU, self.on_quit, mi)
		mb.Append(m, '&Server')
		m = wx.Menu()
		mi = m.Append(-1, '&About')
		self.Bind(wx.EVT_MENU, self.on_about, mi)
		mb.Append(m, '&Help')
		self.SetMenuBar(mb)
	
	def on_connect(self, event):
		
		print "MainFrame:on_connect"
		self.notify_cb("connect")
		
	def on_about(self, event):
		
		print "MainFrame:on_about"
		
	def on_quit(self, event):
		
		self.Destroy()
	
class ClientApp(wx.App):
	
	def OnInit(self):
		
		self.peer_frames = {}
		
		self.main_frame = MainFrame(self.handle_mainframe)
		self.SetTopWindow(self.main_frame)
		self.main_frame.Show()		
		
		self.sock_thread = AsyncSockThread()
		self.sock_thread.start()
		
		self.server_handler = ServerHandler(self.handle_server)
		
		return True
		
	def OnExit(self):
		
		print "Closing sockets..."
		self.sock_thread.stop()
		self.server_handler.close()
		self.sock_thread.join()
		
	def handle_server(self, event, *data):
		
		#wx.CallAfter(getattr(self, attrfunc), *args)
		getattr(self, 'server_' + event)(*data)
		
	def handle_mainframe(self, event, *args):
		
		assert event == "connect" and len(args) == 0
		self.server_handler.connect(('localhost', 3000))
		
	def server_connected(self):
		
		self.server_handler.send('login')
		self.server_handler.send('setname', 'penis_' + str(os.getpid()))
		
	def server_login(self, peer):
		
		pass
	
def main():
	
	app = ClientApp()
	app.MainLoop()
	
if __name__ == '__main__':
	
	main()
