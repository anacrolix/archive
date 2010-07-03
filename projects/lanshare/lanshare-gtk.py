#!/usr/bin/env python

import gtk
from lanshare import Lanshare
import pdb

def stock_image(stock_id):
	image = gtk.Image()
	image.set_from_stock(stock_id, gtk.ICON_SIZE_BUTTON)
	return image

class LanshareGtk(Lanshare):

	def __init__(self):
		Lanshare.__init__(self)

		sharestore = gtk.ListStore(str, str)

		shareview = gtk.TreeView(sharestore)
		shareview.insert_column_with_attributes(
				-1, "Share Name", gtk.CellRendererText(), text=0)
		shareview.insert_column_with_attributes(
				-1, "Local Path", gtk.CellRendererText(), text=1)

		addshrbtn = gtk.Button("New Share", stock=gtk.STOCK_ADD)
		addshrbtn.connect("clicked", self.add_share)

		remshrbtn = gtk.Button("Remove Share", stock=gtk.STOCK_REMOVE)
		remshrbtn.connect("clicked", self.remove_share)

		sharebtns = gtk.VButtonBox()
		sharebtns.add(addshrbtn)
		sharebtns.add(remshrbtn)
		sharebtns.set_layout(gtk.BUTTONBOX_START)

		sharepage = gtk.HBox()
		sharepage.add(shareview)
		sharepage.pack_start(sharebtns, expand=False)

		peerstore = gtk.ListStore(str)

		peerview = gtk.TreeView(peerstore)
		peerview.insert_column_with_attributes(
				-1, "Peer Name", gtk.CellRendererText())
		peerview.insert_column_with_attributes(
				 -1, "Network Address", gtk.CellRendererText(), text=0)

		notebook = gtk.Notebook()
		notebook.append_page(sharepage)
		notebook.set_tab_label_text(sharepage, "Shares")
		notebook.append_page(peerview)
		notebook.set_tab_label_text(peerview, "Peers")

		window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		window.connect("destroy", self.destroy)
		window.add(notebook)
		window.set_title(self.__title__)
		window.show_all()

		from gobject import idle_add
		idle_add(self.gui_idle)

		self.sharestore = sharestore
		self.shareview = shareview

		self.populate_shares()

	def populate_shares(self):
		self.sharestore.clear()
		for virtdir, shrroot in self.config.shares.iteritems():
			self.sharestore.append((virtdir, shrroot))

	def add_share(self, button):
		namelbl = gtk.Label("Share name:")

		entry = gtk.Entry()

		namebox = gtk.HBox(spacing=10)
		namebox.pack_start(namelbl)
		namebox.pack_start(entry)

		pathlbl = gtk.Label("Actual path:")

		pathdlg = gtk.FileChooserDialog(
				"Select Share Root",
				parent=None,
				action=gtk.FILE_CHOOSER_ACTION_SELECT_FOLDER,
				buttons=(
					gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
					gtk.STOCK_OPEN, gtk.RESPONSE_ACCEPT),)

		pathbtn = gtk.FileChooserButton(pathdlg)

		pathbox = gtk.HBox(spacing=10)
		pathbox.pack_start(pathlbl)
		pathbox.pack_start(pathbtn)

		dialog = gtk.Dialog(
				title="Create New Share",
				parent=None,
				flags=gtk.DIALOG_MODAL|gtk.DIALOG_DESTROY_WITH_PARENT,
				buttons=(
					gtk.STOCK_NEW, gtk.RESPONSE_OK,
					gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL))
		dialog.vbox.pack_start(namebox)
		dialog.vbox.pack_start(pathbox)
		dialog.vbox.show_all()

		response = dialog.run()
		#pdb.set_trace()
		if response == gtk.RESPONSE_OK:
			shrroot = pathdlg.get_filename()
			self.config.shares[entry.get_text()] = shrroot
			self.populate_shares()
		dialog.destroy()

	def remove_share(self, widget=None):
		store, rowpaths = self.shareview.get_selection().get_selected_rows()
		for path in rowpaths:
			del self.config.shares[store[path][0]]
		self.populate_shares()

	def gui_idle(self):
		try:
			#print "boobies"
			self.server.serve_forever(use_poll=True, count=1, timeout=0.02)
			return True
		except KeyboardInterrupt:
			import traceback
			traceback.print_exc()
			self.destroy()

	def destroy(self, widget=None):
		print "Main window destroyed"
		self.server.close_all()
		gtk.main_quit()

	def __call__(self):
		#Lanshare.__call__(self)

		gtk.main()

if __name__ == "__main__":
	LanshareGtk()()
