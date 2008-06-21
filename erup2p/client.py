#!/bin/env python

import wx
import threading
import asyncore, asynchat
import socket
import os

EVT_PEERLOGIN_ID = wx.NewId()
EVT_PEERLOGOUT_ID = wx.NewId()
EVT_SOCKERR_ID = wx.NewId()
#EVT_FILEDROP_ID = wx.NewId()

EVT_CUSTOM_TYPE = wx.NewEventType()
EVT_CUSTOM = wx.PyEventBinder(EVT_CUSTOM_TYPE)

class CustomEvent(wx.PyCommandEvent):	
	def __init__(self, evt_id, data=None):
		wx.PyCommandEvent.__init__(self, EVT_CUSTOM_TYPE, evt_id)
		self.data = data

class ServerHandler(asynchat.async_chat):
	buffer = ''
	MESSAGES = {'connected': 3, 'disconnected': 2}
	cur_msg = None
	msg_parms = []
	def __init__(self, master):
		asynchat.async_chat.__init__(self)
		self.master = master
		self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.set_terminator("\r\n")
		self.connect(('localhost', 3000))
	def handle_connect(self):
		self.send("\r\n".join(['matt' + str(os.getpid()), '']))
	def handle_error(self):
		#wx.CallAfter(self.master.on_custom, CustomEvent(EVT_SOCKERR_ID, 'call after server fail'))
		wx.PostEvent(self.master, CustomEvent(EVT_SOCKERR_ID, 'Server connection failure'))
		self.close()
	def collect_incoming_data(self, data):
		self.buffer += data
	def process_msg(self):
		assert len(self.msg_parms) == self.MESSAGES[self.cur_msg]
		if self.cur_msg == 'connected':
			wx.PostEvent(self.master, CustomEvent(EVT_PEERLOGIN_ID, {'name': self.msg_parms[0], 'addr': self.msg_parms[1:3]}))
		elif self.cur_msg == 'disconnected':
			wx.PostEvent(self.master, CustomEvent(EVT_PEERLOGOUT_ID, self.msg_parms))
		else:
			assert False
	def found_terminator(self):
		print self.buffer
		if self.cur_msg == None:
			assert self.MESSAGES.has_key(self.buffer)
			self.cur_msg = self.buffer
		else:
			self.msg_parms.append(self.buffer)
		if len(self.msg_parms) == self.MESSAGES[self.cur_msg]:
			self.process_msg()
			self.cur_msg = None
			self.msg_parms = []
		if self.cur_msg == None:
			assert len(self.msg_parms) == 0
		else:
			assert len(self.msg_parms) < self.MESSAGES[self.cur_msg]	
		self.buffer = ""		

class AsynSockThread(threading.Thread):
	#def __init__(self)
		#threading.Thread.__init__(self)
	def run(self):
		print "Starting asyncore loop"
		# low timeout makes it die faster after last close
		asyncore.loop(timeout=1)
		print "Finished asyncore loop"

class PeerFileDropTarget(wx.FileDropTarget):
	def __init__(self, target, callback):
		wx.FileDropTarget.__init__(self)
		self.target = target
		self.callback = callback
	def OnDropFiles(self, x, y, filenames):
		print filenames
		print self.target.HitTest((x, y))
		self.callback(self.target.HitTest((x, y)), filenames)

class ChatWindow(wx.Frame):
	def __init__(self, parent, title, id=wx.ID_ANY):
		wx.Frame.__init__(self, parent, id, title)
		self.sizer = wx.BoxSizer(wx.VERTICAL)
		self.text_history = wx.TextCtrl(self, value="history")
		self.text_message = wx.TextCtrl(self, value="message")
		self.sizer.Add(self.text_history, 1, wx.EXPAND)
		self.sizer.Add(self.text_message, 0, wx.EXPAND)
		self.SetSizer(self.sizer)

class MainWindow(wx.Frame):	
	ID_ABOUT = wx.NewId()
	ID_EXIT = wx.NewId()
	transfer_frames = {}
	peers = {}
	
	def on_custom(self, evt):		
		evt_id = evt.GetId()
		if evt_id == EVT_SOCKERR_ID:
			wx.MessageDialog(self, evt.data, "Socket error", wx.ICON_EXCLAMATION).ShowModal()
			print evt.data
			self.Close()
		elif evt_id == EVT_PEERLOGIN_ID:
			self.peer_listbox.Append(evt.data['name'], evt.data['addr'])
		elif evt_id == EVT_PEERLOGOUT_ID:
			for n in range(self.peer_listbox.GetCount()):
				print self.peer_listbox.GetClientData(n)
				if self.peer_listbox.GetClientData(n) == evt.data:
					self.peer_listbox.Delete(n)
					self.peers[str(evt.data)].Close(True)
					break
		else:
			print "Unknown event ID!"
			assert False

	def __init__(self, parent, title):
		# super ctor
		wx.Frame.__init__(self, parent, wx.ID_ANY, title)
		# status bar
		self.CreateStatusBar()
		# menu bar
		actionMenu = wx.Menu()
		
		self.Bind(wx.EVT_MENU, self.on_about, actionMenu.Append(self.ID_ABOUT, "&About", "More information regarding this program"))
		#wx.EVT_MENU(self, self.ID_ABOUT, self.OnAbout)
		actionMenu.AppendSeparator()
		self.Bind(wx.EVT_MENU, self.on_close, actionMenu.Append(self.ID_EXIT, "E&xit", "Terminate the program"))
		menuBar = wx.MenuBar()
		menuBar.Append(actionMenu, "&Actions")
		self.SetMenuBar(menuBar)
		# contents
		self.peer_listbox = wx.ListBox(self)
		self.peer_filedrop = PeerFileDropTarget(self.peer_listbox, self.send_files)
		self.peer_listbox.SetDropTarget(self.peer_filedrop)
		# server socket handler
		self.server_handler = ServerHandler(self)
		
		self.Bind(EVT_CUSTOM, self.on_custom)
		self.Bind(wx.EVT_CLOSE, self.on_close)
		self.peer_listbox.Bind(wx.EVT_LEFT_DCLICK, self.on_dblclk_peer)
	def on_about(self, event):
		# this is to replaced by a wx aboutdialog later
		dialog = wx.MessageDialog(self, "A P2P file sharing utility\n"
			"for augmenting IM shortcomings", "About wxPyShare", wx.OK)
		dialog.ShowModal()
		dialog.Destroy()
	def on_close(self, event):
		print "OnCloseWin"
		self.server_handler.close()
		self.Destroy()
	def send_files(self, peer_index, file_names):
		peer_name = self.peer_listbox.GetString(peer_index)
		peer_addr = self.peer_listbox.GetClientData(peer_index)
		print str(peer_addr)
		print "send_files:", peer_name, file_names
		assert not self.transfer_frames.has_key(str(peer_addr))
		self.transfer_frames[str(peer_addr)] = True
	def on_dblclk_peer(self, event):
		print "j00 dblclk'd!"
		print event.GetPosition()
		peer_index = self.peer_listbox.HitTest(event.GetPosition())
		print peer_index
		self.peers[str(self.peer_listbox.GetClientData(peer_index))] = ChatWindow(self, "hi")
		self.peers[str(self.peer_listbox.GetClientData(peer_index))].Show(True)

def main():
	app = wx.PySimpleApp()
	frame = MainWindow(None, "Eru P2P")
	#app.SetTopWindow(frame)
	frame.Show(True)
	sock_thread = AsynSockThread()
	sock_thread.start()
	app.MainLoop()
	print "left wx mainloop"
	#del sock_thread
	#frame.Close()
	#sock_thread.join(1)	

if __name__ == "__main__":
	main()
