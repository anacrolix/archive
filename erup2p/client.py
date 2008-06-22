#!/bin/env python

import wx
import threading
import asyncore, asynchat
import socket
import os

class ServerHandler(asynchat.async_chat):
	LINE_TERM = '\r\n'
	MESSAGES = {'connected': 3, 'disconnected': 2}
	buffer = ''
	cur_msg = None
	msg_parms = []
	
	def __init__(self, master):
		asynchat.async_chat.__init__(self)
		self.master = master
		self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.set_terminator("\r\n")
		self.connect(('localhost', 3000))
		
	def handle_connect(self):
		self.send('\r\n'.join(['matt' + str(os.getpid()), '']))

	def handle_error(self):
		wx.CallAfter(self.master.server_error, 'Peer server connection failure!')
		self.close()
		
	def collect_incoming_data(self, data):
		print data
		self.buffer += data
		
	def process_msg(self):
		assert len(self.msg_parms) == self.MESSAGES[self.cur_msg]
		if self.cur_msg == 'connected':
			wx.CallAfter(self.master.peer_login, self.msg_parms[0], (self.msg_parms[1], eval(self.msg_parms[2])))
		elif self.cur_msg == 'disconnected':
			wx.CallAfter(self.master.peer_logout, (self.msg_parms[0], eval(self.msg_parms[1])))
		else:
			print self.cur_msg
			
	def found_terminator(self):
		print "found_terminator"
		print self.buffer
		print self.cur_msg
		if self.cur_msg == None:
			if not self.MESSAGES.has_key(self.buffer):
				# new format
				unpacked = eval(self.buffer)
				print unpacked
				assert unpacked[0] == 'message'
				wx.CallAfter(self.master.peer_message, unpacked[1], unpacked[2])
				self.buffer = ''
				return
				
			print "had key"
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
		self.buffer = ''
		print "finished found_terminator"
	
	def handle_close(self):
		wx.CallAfter(self.master.server_closed, 'Master server disconnected!')
		self.close()
	
	def msg_peer(self, addr, msg):
		self.send(str((addr, msg)) + self.LINE_TERM)

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

class PeerWindow(wx.Frame):
	
	def __init__(self, parent, name, addr, chatsock):
		wx.Frame.__init__(self, parent, wx.ID_ANY, name)
		
		self.chatsock = chatsock
		self.addr = addr
		
		self.sizer = wx.BoxSizer(wx.VERTICAL)
		self.text_history = wx.TextCtrl(self, value="history", style=wx.TE_MULTILINE|wx.TE_AUTO_URL|wx.TE_READONLY)
		self.text_message = wx.TextCtrl(self, style=wx.TE_PROCESS_ENTER)
		self.sizer.Add(self.text_history, 1, wx.EXPAND)
		self.sizer.Add(self.text_message, 0, wx.EXPAND)
		self.SetSizer(self.sizer)
		
		self.Bind(wx.EVT_TEXT_ENTER, self.on_enter)
		self.Bind(wx.EVT_CLOSE, self.on_close)
		
	def on_enter(self, event):
		msg_str = self.text_message.GetValue()
		print msg_str
		self.chatsock.msg_peer(self.addr, msg_str)
		self.text_message.Clear()
	
	def on_close(self, event):
		self.Show(False)

class PeerList(dict):
	
	def __init__(self, listbox):
		self.listbox = listbox
		
	def peer_login(self, parent, name, addr):
		addr_str = str(addr)
		assert not self.has_key(addr_str)
		self.listbox.Append(name, addr_str)
		self[addr_str] = PeerWindow(parent, name, addr, parent.server_handler)
		
	def peer_logout(self, addr):
		addr_str = str(addr)
		print "addr_str:", addr_str
		print "PeerList:", str(self)
		assert self.has_key(addr_str)
		for n in range(self.listbox.GetCount()):
			if self.listbox.GetClientData(n) == addr_str:
				self.listbox.Delete(n)
				break
		else:
			assert False
	
	def peer_message(self, addr, msg):
		addr_str = str(addr)
		assert self.has_key(addr_str)
		if not self[addr_str].IsShown():
			print "Showing hidden PeerWindow"
			self[addr_str].Show(True)
		if not self[addr_str].text_history.IsEmpty():
			self[addr_str].text_history.AppendText('\n')
		self[addr_str].text_history.AppendText(msg)	

class MainWindow(wx.Frame):	
	
	def server_error(self, info_str):
		wx.MessageDialog(self, info_str, "Server Error", wx.ICON_EXCLAMATION).ShowModal()		
		self.Close() # (True)?
		
	def peer_login(self, name, addr):
		self.peers.peer_login(self, name, addr)		
	
	def peer_logout(self, addr):
		self.peers.peer_logout(addr)
		
	def peer_message(self, addr, message):
		self.peers.peer_message(addr, message)
	
	def server_closed(self, info_str):
		wx.MessageDialog(self, info_str, "Server Shutdown", wx.ICON_EXCLAMATION).ShowModal()
		
	def __init__(self):
		# super constructor
		wx.Frame.__init__(self, None, wx.ID_ANY, 'Eru P2P')
		# status bar
		self.CreateStatusBar()
		# menu bar
		action_menu = wx.Menu()
		menu_item = action_menu.Append(wx.ID_ANY, "&About", "Information about this program")
		self.Bind(wx.EVT_MENU, self.on_about, menu_item)
		action_menu.AppendSeparator()
		menu_item = action_menu.Append(wx.ID_ANY, "E&xit", "Terminate the program")
		self.Bind(wx.EVT_MENU, self.on_close, menu_item)
		menu_bar = wx.MenuBar()
		menu_bar.Append(action_menu, "&Actions")
		self.SetMenuBar(menu_bar)
		# contents
		self.peer_listbox = wx.ListBox(self)
		self.peer_filedrop = PeerFileDropTarget(self.peer_listbox, self.send_files)
		self.peer_listbox.SetDropTarget(self.peer_filedrop)
		# server socket handler
		self.server_handler = ServerHandler(self)
		
		self.Bind(wx.EVT_CLOSE, self.on_close)
		self.peer_listbox.Bind(wx.EVT_LEFT_DCLICK, self.on_dclick_peers)
		
		self.peers = PeerList(self.peer_listbox)
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
	def on_dclick_peers(self, event):
		index = self.peer_listbox.HitTest(event.GetPosition())
		key = self.peer_listbox.GetClientData(index)
		self.peers[key].Show(True)
		#self.peers[str(self.peer_listbox.GetClientData(peer_index))] = ChatWindow(self, "hi")
		#self.peers[str(self.peer_listbox.GetClientData(peer_index))].Show(True)

def main():
	app = wx.PySimpleApp()
	frame = MainWindow()
	frame.Show()
	AsynSockThread().start()
	app.MainLoop()
	print "left wx mainloop"

if __name__ == "__main__":
	main()
