#!/bin/env python

import wx
import threading

class PeerServerClientThread(threading.Thread):
	def __init__(self, window):
		threading.Thread.__init__(self)
		self.window = window
		self.quit = False
	def run(self):
		while not self.quit: pass
	def abort(self):
		self.quit = True
	

class TestFileDropTarget(wx.FileDropTarget):
	def __init__(self, target):
		wx.FileDropTarget.__init__(self)
		self.target = target
	def OnDropFiles(self, x, y, filenames):
		print filenames
		print self.target.HitTest((x, y))

class MainWindow(wx.Frame):
	ID_ABOUT = wx.NewId()
	ID_EXIT = wx.NewId()
	def __init__(self, parent, title):
		# super ctor
		wx.Frame.__init__(self, parent, wx.ID_ANY, title)
		# status bar
		self.CreateStatusBar()
		# menu bar
		actionMenu = wx.Menu()
		actionMenu.Append(self.ID_ABOUT, "&About", "More information regarding this program")
		wx.EVT_MENU(self, self.ID_ABOUT, self.OnAbout)
		actionMenu.AppendSeparator()
		actionMenu.Append(self.ID_EXIT, "E&xit", "Terminate the program")
		wx.EVT_MENU(self, self.ID_EXIT, self.OnExit)
		menuBar = wx.MenuBar()
		menuBar.Append(actionMenu, "&Actions")
		self.SetMenuBar(menuBar)
		# contents
		self.peer_listbox = wx.ListBox(self)
		self.peer_listbox.InsertItems(['sup bitch lols', 'fag'], 0)
		self.peer_filedrop = TestFileDropTarget(self.peer_listbox)
		self.peer_listbox.SetDropTarget(self.peer_filedrop)
		#self.control = wx.TextCtrl(self, 1, style=wx.TE_MULTILINE|wx.TE_READONLY)
		#self.test_drop = TestFileDropTarget(self.control)
		#self.control.SetDropTarget(self.test_drop)
		# finish
		# server socket thread
		self.peer_thread = ServerChatThread(self)
		self.peer_thread.start()
		self.Show(True)
	def OnAbout(self, event):
		dialog = wx.MessageDialog(self, "A P2P file sharing utility\n"
			"for augmenting IM shortcomings", "About wxPyShare", wx.OK)
		dialog.ShowModal()
		dialog.Destroy()
	def OnExit(self, event):
		self.peer_thread.abort()
		self.Close(True)

if __name__ == "__main__":
	app = wx.PySimpleApp()
	frame = MainWindow(None, "wxPyShare")
	app.MainLoop()
