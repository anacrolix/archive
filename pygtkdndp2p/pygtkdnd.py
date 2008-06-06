#!/bin/env python

import pygtk
pygtk.require('2.0')
import gtk
import os
import socket
import gobject
import stat
import gnomevfs

#import gobject

class FileTransfer:
	def connect(self):
		self.sock.connect((self.host, self.port))
	def send(self, source, condition):
		assert(condition == gobject.IO_OUT)
		print self.path
		print self.name
		self.sock.send(self.name + "\r\n" + str(os.stat(os.path.join(self.path, self.name))[stat.ST_SIZE]) + "\r\n" + open(os.path.join(self.path, self.name), "rb").read())
		return False
	def __init__(self, path, name, host, port):	
		self.path = path
		self.name = name
		self.host = host
		self.port = port	
		self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.connect()

class TransferWindow:
	ALLOWED_TARGETS = ['text/uri-list']
	active_transfers = {}
	def drag_motion_cb(self, widget, context, xpos, ypos, time):
		print 'Drag and drop motion (%d, %d) in TransferWindow' % ( xpos, ypos)
		context.drag_status(gtk.gdk.ACTION_COPY, time)
		return True
		
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
		
	def drag_data_received_cb(self, widget, context, x, y, sel, type, time):
		files = sel.data.split("\r\n")[:-1]
		print "TransferWindow received", len(files), "files:"
		for file in files:
			print file
			path = gnomevfs.URI(file).path
			new_ft = FileTransfer(os.path.dirname(path), os.path.basename(path), 'localhost', 3000)
			gobject.io_add_watch(new_ft.sock, gobject.IO_OUT, new_ft.send)
			self.active_transfers[file] = new_ft
	
	def __init__(self):
		w = gtk.Window(gtk.WINDOW_TOPLEVEL)
		w.drag_dest_set(0, [], 0)
		w.connect('destroy', lambda w: gtk.main_quit())
		w.connect('drag_motion', self.drag_motion_cb)
		w.connect('drag_drop', self.drag_drop_cb)
		w.connect('drag_data_received', self.drag_data_received_cb)
		w.show()
		self.window = w
		
def main():
	gtk.main()
	
if __name__ == "__main__":
	TransferWindow()
	main()
