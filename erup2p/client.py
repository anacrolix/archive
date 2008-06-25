#!/bin/env python

import wx
import threading
import asyncore, asynchat
import socket
import os
import time

class ServerHandler():
	
	class ServerDispatcher(asynchat.async_chat):
		
		pass
		
	def notify(self, event, *args):
		
		self.notify_cb(event, *args)
	
	def __init__(self, notify_cb):
		
		self.dispatcher = ServerHandler.ServerDispatcher()		

class AsyncSockThread(threading.Thread):

	quit = False
	
	def __init__(self, timeout=1.0):
		
		threading.Thread.__init__(self)
		self.timeout = timeout
	
	def run(self):
		
		while True:
			asyncore.loop(timeout=self.timeout)
			if self.quit: break
			time.sleep(self.timeout)
	
	def stop(self):
		
		self.quit = True

class PeerFileDropTarget(wx.FileDropTarget):
	
	pass

class PeerFrame(wx.Frame):
	
	pass

class MainFrame(wx.Frame):
	
	def __init__(self):
		
		wx.Frame.__init__(self, None, title='Eru P2P')
		
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
		
	def on_about(self, event):
		
		print "MainFrame:on_about"
		
	def on_quit(self, event):
		
		self.Destroy()
	
class ClientApp(wx.App):
	
	def OnInit(self):
		
		self.peer_frames = {}
		
		self.main_frame = MainFrame()
		self.SetTopWindow(self.main_frame)
		self.main_frame.Show()
		
		self.sock_thread = AsyncSockThread()
		self.sock_thread.start()
		
		self.server_handler = ServerHandler(self.notify_cb)
		
		return True
		
	def OnExit(self):
		
		print "Closing sockets..."
		self.sock_thread.stop()
		self.sock_thread.join()
		
	def notify_cb(self, attrfunc, *args):
		
		wx.CallAfter(self.__getattribute__(attrfunc), *args)

def main():
	
	app = ClientApp()
	app.MainLoop()
	
if __name__ == '__main__':
	
	main()
