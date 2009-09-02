#!/usr/bin/env python

from __future__ import division
import gobject
import gtk
import math
import os
import pdb
import socket
import urllib2
import zlib

class DragDataDialog:
    def __init__(self, title):
        window = gtk.Window()
        window.set_title(title)
        ddstore = gtk.ListStore(str, str)
        targview = gtk.TreeView(ddstore)
        targview.append_column(
                gtk.TreeViewColumn("Target", gtk.CellRendererText(), text=0))
        hbox = gtk.HBox()
        hbox.add(targview)
        databuf = gtk.TextBuffer()
        dataview = gtk.TextView(databuf)
        dataview.set_wrap_mode(gtk.WRAP_CHAR)
        hbox.add(gtk.TextView(databuf))
        window.add(hbox)
        window.show_all()
        #self.databuf = databuf
        targview.get_selection().connect("changed", self.target_selection_changed, databuf)

        self.ddstore = ddstore
    def add_drag_data(self, target, data):
        print target, data
        self.ddstore.append((target, repr(data)))
    def target_selection_changed(self, treesel, databuf):
        model, iter = treesel.get_selected()
        databuf.set_text(model.get_value(iter, 1))

def has_single_flag(value):
    return not math.modf(math.log(value, 2))[0]

class Transfer:
    def __init__(self, uri, progbar):
        print repr(uri)
        progbar.set_text(uri)
        progbar.show()
        self.progbar = progbar
        self.infile = urllib2.urlopen(uri).fp
        #print dir(self.infile.fp)
        self.infile.seek(0, os.SEEK_END)
        self.filesize = self.infile.tell()
        self.infile.seek(0)
        self.outgoing = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.outgoing.connect(('localhost', 1337))
        self.compressor = zlib.compressobj()
        gobject.io_add_watch(
                self.outgoing,
                gobject.IO_OUT | gobject.IO_ERR | gobject.IO_HUP, self.outgoing_cb,
                priority=gobject.PRIORITY_DEFAULT_IDLE)
    def send_more(self):
        return bool(a)
    def outgoing_cb(self, source, condition):
        print condition
        assert has_single_flag(condition)
        if condition & gobject.IO_OUT:
            a = self.infile.read(0x100)
            if a:
                b = self.compressor.compress(a)
            else:
                b = self.compressor.flush()
                self.infile.close()
            self.outgoing.sendall(b)
            if a:
                self.progbar.set_fraction(self.infile.tell() / self.filesize)
                return True
            else:
                self.outgoing.close()
                self.progbar.set_fraction(1.0)
                return False
        elif condition & gobject.IO_ERR:
            assert False
        elif condition & gobject.IO_HUP:
            assert False
        else:
            assert False
        return False

class MainWindow:
    def drag_data_received(self, widget, drag_context, x, y, selection_data, info, timestamp):
        #if not timestamp in self.dnddlgs:
        #    self.dnddlgs[timestamp] = DragDataDialog(str(timestamp))
        #self.dnddlgs[timestamp].add_drag_data(selection_data.target, selection_data.data)
        print "received"
        print selection_data.data
        for uri in selection_data.data.split("\r\n"):
            if not uri or uri == "\0": continue
            progbar = gtk.ProgressBar()
            self.vbox.add(progbar)
            Transfer(uri, progbar)
    def drop_cb(self, widget, drag_context, x, y, timestamp):
        print drag_context.targets
        widget.drag_get_data(drag_context, "text/uri-list", timestamp)
        drag_context.finish(True, False, timestamp)
        return True
    def drag_motion(self, widget, drag_context, x, y, timestamp):
        print "drag"
        drag_context.drag_status(gtk.gdk.ACTION_COPY, timestamp)
        return True
    def __init__(self):
        w = gtk.Window()
        w.set_title("Drop Test Window")
        w.drag_dest_set(0, [], 0)
        w.connect("drag-motion", self.drag_motion)
        w.connect("drag-drop", self.drop_cb)
        w.connect("drag-data-received", self.drag_data_received)
        w.connect("destroy", lambda w: gtk.main_quit())
        self.vbox = gtk.VBox()
        w.add(self.vbox)
        w.show_all()
        self.dnddlgs = {}

MainWindow()
gtk.main()
