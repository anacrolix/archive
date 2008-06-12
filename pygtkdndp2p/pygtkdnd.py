#!/bin/env python

import pygtk
pygtk.require('2.0')
import gtk
import os
import socket
import gobject
import stat
import gnomevfs

class FileTransfer:
	def update(self, fraction):
		self.update_cb(self.path, fraction)
	def connect(self):	
		try:
			self.sock.connect((self.host, self.port))
		except socket.error:
			print "poo :("
			return False
		return True	
	def io_cb(self, source, condition):
		if (condition == gobject.IO_OUT):
			print self.path
			filesize = os.stat(self.path)[stat.ST_SIZE]
			packet = "\r\n".join((
				os.path.basename(self.path),
				str(filesize),
				open(self.path, "rb").read()))
			assert(self.sock.send(packet) == len(packet))
			self.update(1.0)
			print "Send complete"
			return False
		else:
			print "FileTransfer() failed"
			#gobject.source_remove(self.io_src_id)
			self.sock.close()
			self.update(0.0)
			return False
	def __init__(self, path, host, port, update_cb):	
		self.path = path
		self.host = host
		self.port = port
		self.update_cb = update_cb
		self.sock = socket.socket(
			socket.AF_INET, socket.SOCK_STREAM)
		self.io_src_id = gobject.io_add_watch(self.sock, 
			gobject.IO_ERR | gobject.IO_HUP | gobject.IO_OUT,
			self.io_cb)
		self.connect()

class TransferWindow:
	ALLOWED_TARGETS = ['text/uri-list']
	active_transfers = {}
	def drag_motion_cb(self, widget, context, xpos, ypos, time):
		print 'Drag and drop motion (%d, %d) in TransferWindow' % (xpos, ypos)
		context.drag_status(gtk.gdk.ACTION_COPY, time)
		return True
	
	def transfer_update(self, path, progress):
		self.active_transfers[path].prog_ctrl.set_fraction(progress)
	
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
			new_ft = FileTransfer(path, 'localhost', 3000,
				self.transfer_update)
			self.active_transfers[path] = new_ft
			pb = gtk.ProgressBar()
			pb.set_text(path)
			new_ft.prog_ctrl = pb
			pb.show()
			self.table.resize(len(self.active_transfers), 1)
			self.table.attach(pb, 0, 1, len(self.active_transfers) - 1,
				len(self.active_transfers))
	
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
		
def main():
	TransferWindow()
	gtk.main()
		
if __name__ == "__main__":
	main()
