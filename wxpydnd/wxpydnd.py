import wx

ID_ABOUT = 100
ID_EXIT = 200

class MainWindow(wx.Frame):
	def __init__(self, parent, title):
		# super ctor
		wx.Frame.__init__(self, parent, wx.ID_ANY, title, size=(400,400))
		# status bar
		self.CreateStatusBar()
		# menu bar
		actionMenu = wx.Menu()
		actionMenu.Append(ID_ABOUT, "&About", "More information regarding this program")
		wx.EVT_MENU(self, ID_ABOUT, self.OnAbout)
		actionMenu.AppendSeparator()
		actionMenu.Append(ID_EXIT, "E&xit", "Terminate the program")
		wx.EVT_MENU(self, ID_EXIT, self.OnExit)
		menuBar = wx.MenuBar()
		menuBar.Append(actionMenu, "&Actions")
		self.SetMenuBar(menuBar)
		# contents
		self.control = wx.TextCtrl(self, 1, style=wx.TE_MULTILINE)
		# finish
		self.Show(True)
	def OnAbout(self, event):
		dialog = wx.MessageDialog(self, "A P2P file sharing utility\n"
			"for augmenting IM shortcomings", "About wxPyShare", wx.OK)
		dialog.ShowModal()
		dialog.Destroy()
	def OnExit(self, event):
		self.Close(True)

if __name__ == "__main__":
	app = wx.PySimpleApp()
	frame = MainWindow(None, "wxPyShare")
	app.MainLoop()
