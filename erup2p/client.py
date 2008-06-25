#!/bin/env python

import wx
import threading
import asyncore, asynchat
import socket
import os

class ServerHandler():
	
	class ServerDispatcher(asynchat.async_chat):
		
		pass
		
	def notify(self, event, *args):
		
		self.notify_cb(event, *args)
	
	def __init__(self, notify_cb):
		
		self.dispatcher = ServerDispatcher()		

class AsyncSockThread(threading.Thread):
	
	pass

class PeerFileDropTarget(wx.FileDropTarget):
	
	pass

class PeerFrame(wx.Frame):
	
	pass

class MainFrame(wx.Frame):
	
	def __init__(self):
		
		wx.Frame.__init__(self, None, title='Eru P2P')
	
class ClientApp(wx.App):
	
	def OnInit(self):
		
		self.peer_frames = {}
		
		self.main_frame = MainFrame()
		self.SetTopWindow(self.main_frame)
		self.main_frame.Show()
		
		return True

def main():
	
	app = ClientApp()
	app.MainLoop()
	
if __name__ == '__main__':
	
	main()
