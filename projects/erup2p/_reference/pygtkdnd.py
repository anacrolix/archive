#!/bin/env python

import pygtk
pygtk.require('2.0')
import gtk
import os
import socket
import gobject
import stat
import gnomevfs

class FileSender:
	def notify(self, fraction, info=""):
		self.notify_cb(self, fraction, info)
	def start(self):
		self.notify(0, "Opening file...")
		self.file_obj = open(os.path.join(self.base_path, self.rel_path), "rb")
		self.file_obj.seek(0, os.SEEK_END)
		self.file_size = self.file_obj.tell()
		print "File size:", self.file_size
		self.file_obj.seek(0, os.SEEK_SET)
		#self.file_size = os.fstat(self.file_obj)[stat.ST_SIZE]
		self.notify(0, "Opening socket...")
		self.socket = socket.socket(
			socket.AF_INET, socket.SOCK_STREAM)
		self.notify(0, "Connecting...")
		try:
			self.socket.connect((self.peer_name, self.rem_port))
		except socket.error:
			self.notify(0, "Connection failed!")
			return False
		self.socket.send("\r\n".join([
			self.rel_path, str(self.file_size), '']))
		self.sock_src_id = gobject.io_add_watch(self.socket,
			gobject.IO_ERR | gobject.IO_HUP | gobject.IO_OUT,
			self.socket_io_cb)
		return True
	def socket_io_cb(self, source, condition):
		print "IO Source event:", condition
		if condition == gobject.IO_OUT:
			progress = float(self.file_obj.tell()) / self.file_size
			print "Progress:", progress
			self.notify(progress)			
			data = self.file_obj.read(0x1000)
			if len(data) > 0:
				assert(self.socket.send(data) == len(data))
				return True
			else:
				self.socket.close()
				self.file_obj.close()
				print "File sent!"
				return False
		elif condition == gobject.IO_ERR:
			pass
		elif condition == gobject.IO_HUP:
			pass
		print "Unexpected condition!"
		assert(false)
		return False
	def __init__(self, base_path, rel_path, peer_name, rem_port, notify_cb):		
		self.base_path = base_path
		self.rel_path = rel_path
		self.peer_name = peer_name
		self.rem_port = rem_port
		self.notify_cb = notify_cb

class TransferWindow:
	ALLOWED_TARGETS = ['text/uri-list']
	active_transfers = {}
	def drag_motion_cb(self, widget, context, xpos, ypos, time):
		print 'Drag and drop motion (%d, %d) in TransferWindow' % (xpos, ypos)
		context.drag_status(gtk.gdk.ACTION_COPY, time)
		return True
	
	def transfer_update(self, ft_obj, progress, info=""):
		pb = self.active_transfers[ft_obj][1]
		pb.set_fraction(progress)
		text = ft_obj.rel_path
		if info: text += ": " + info
		pb.set_text(text)
	
	def drag_drop_cb(self, widget, context, xpos, ypos, time):
		print 'Drag and drop source targets:', context.targets
		context.finish(True, True, time)
		for target in context.targets:
			if target in self.ALLOWED_TARGETS: break
		else:
			print 'Did not locate allowed drag data targets'
			return False
			print 'Requested target:', target
		widget.drag_get_data(context, target)
		return True
	
	def drag_data_received_cb(
			self, widget, context, x, y, sel, type, time):
		uri_list = sel.data.split("\r\n")[:-1]
		print "TransferWindow received", len(uri_list), "URIs:"
		for uri in uri_list:
			path = gnomevfs.URI(uri).path
			print uri, "(" + path + ")"
			base = os.path.basename(path)
			dir = os.path.dirname(path)
			print "dir:", dir
			print "base:", base 
			
			pb = gtk.ProgressBar()
			pb.show()
			self.table.resize(len(self.active_transfers) + 1, 1)
			self.table.attach(pb, 0, 1, len(self.active_transfers),
				len(self.active_transfers) + 1)
			pb.set_text("Initializing...")

			new_ft = FileTransfer(dir, base, 'localhost', 3000,
				self.transfer_update)
			self.active_transfers[new_ft] = (new_ft, pb)
			new_ft.start()
	
	def __init__(self):
		w = gtk.Window(gtk.WINDOW_TOPLEVEL)
		w.drag_dest_set(0, [], 0)
		w.connect('destroy', lambda w: gtk.main_quit())
		w.connect('drag_motion', self.drag_motion_cb)
		w.connect('drag_drop', self.drag_drop_cb)
		w.connect('drag_data_received', self.drag_data_received_cb)
		w.show()
		t = gtk.Table()
		t.show()
		w.add(t)
#w.add(tc)
		self.table = t
		self.window = w

class OnlineListMonitor:
	def __init__(self, server_name, server_port):
		self.server_name = server_name
		self.server_port = server_port
		
class FileAccepter:
	def start_listen(self):
		self.listen_socket = socket.socket(
			socket.AF_INET, socket.SOCK_STREAM)
		self.listen_socket.bind()

class PeerListWindow:
	def __init__(self):
		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		self.window.set_title("PyGTK File Sharer")
		self.window.connect('destroy', gtk.main_quit)
		self.online_list_store = gtk.TreeStore(str, str)
		self.online_list_store.append(None, ["hi", "eruanno.net"])	
		self.online_list_view = gtk.TreeView(self.online_list_store)
		self.online_list_column = gtk.TreeViewColumn("Peer")
		self.online_list_view.append_column(self.online_list_column)
		self.online_list_cell = gtk.CellRendererText()
		self.online_list_column.pack_start(self.online_list_cell, False)
		self.online_list_column.add_attribute(self.online_list_cell, "text", 0)
		self.window.add(self.online_list_view)
		self.window.show_all()
		
def main():
	PeerListWindow()
	gtk.main()
		
if __name__ == "__main__":
	main()
