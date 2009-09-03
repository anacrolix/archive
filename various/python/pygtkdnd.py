#!/usr/bin/env python

from __future__ import division

import errno
import gobject
import gtk
import hashlib
import math
import os, os.path
import pdb
import socket
import struct
import tempfile
import urllib2
import urlparse
import zlib

import common

class FileSend:
    def __init__(self, uri, progbar):
        infile = urllib2.urlopen(uri)
        self.length = int(infile.headers["Content-Length"])
        progbar.set_text(infile.url)
        #progbar.set_orientation(gtk.PROGRESS_RIGHT_TO_LEFT)
        progbar.show()
        self.outgoing = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.outgoing.setblocking(True)
        self.outgoing.connect(('localhost', 1337))
        self.compressor = zlib.compressobj()
        #gobject.io_add_watch(
                #self.outgoing.fileno(),
                #gobject.IO_OUT | gobject.IO_ERR | gobject.IO_HUP,
                #self.outgoing_cb,
                #priority=gobject.PRIORITY_DEFAULT_IDLE)
        gobject.timeout_add(10, self.outgoing_cb)
        self.progbar = progbar
        header = repr({
                "length": self.length,
                "name": os.path.basename(urlparse.urlparse(uri).path),
                "type": infile.headers.type,
            })
        print header
        self.pending = common.Buffer(self.compressor.compress(struct.pack("Q", len(header)) + header))
        #print repr(self.pending)
        self.infile = infile
    def __del__(self):
        print "del transfer"
        self.outgoing.close()
        self.infile.close()
    def outgoing_cb(self):
        #if condition == gobject.IO_OUT:
        while not self.pending:
            a = self.infile.read(0x1000)
            if a:
                self.pending.append(self.compressor.compress(a))
            else:
                self.infile.close()
                self.pending.append(self.compressor.flush())
                break
        if self.pending:
            #try:
            self.outgoing.settimeout(0.0)
            b = self.outgoing.send(self.pending.copy())
            #except socket.error as e:
                #if e.errno in (errno.WSAECONNRESET,):
                    #self.progbar.set_text(self.infile.url + " [CONNECTION RESET]")
                    #del self
                    #return False
                #if not e.errno in (errno.WSAEWOULDBLOCK,):
                    #raise
            #else:
            self.pending.drop(b)
        if self.infile.fp:
            f = self.infile.fp.tell() / self.length
            #if self.progbar.get_fraction() // 0.01 != f // 0.01:
            #    print "update progbar", f
            self.progbar.set_fraction(f)
        elif not self.pending:
            self.progbar.set_fraction(1.0)
            del self
            return False
        return True
        #else:
            #del self
            #return False

class FileReceive(object):
    def __init__(self, conn, address, progress, parent):
        self.dcmprss = zlib.decompressobj()
        gobject.io_add_watch(
                conn,
                ~gobject.IO_OUT,
                self.event_cb,
                priority=gobject.PRIORITY_DEFAULT_IDLE)
        self.state = 0
        self.buffer = common.Buffer()
        progress.show()
        progress.set_text("Waiting for header...")
        #progress.show()
        self.progress = progress
        self.address = address
        self.parent = parent
    def user_wants_file(self):
        label = gtk.Label(
                "%s:%d has offered you a file!\n%s (%s - %d bytes)\nDo you want this file?"
                    % (self.address[0], self.address[1], self.name, self.type, self.length))
        dialog = gtk.Dialog(
                "Accept offered file?",
                self.parent,
                flags=gtk.DIALOG_DESTROY_WITH_PARENT,
                buttons=(gtk.STOCK_YES, gtk.RESPONSE_ACCEPT, gtk.STOCK_NO, gtk.RESPONSE_REJECT))
        dialog.vbox.add(label)
        label.show()
        #pdb.set_trace()
        response = dialog.run()
        dialog.destroy()
        print "dialog response", response
        return response in (gtk.RESPONSE_ACCEPT,)
    def __del__(self):
        print "del FileReceive"
    def event_cb(self, source, condition):
        # check only 1 condition is set
        #print condition
        if condition & gobject.IO_IN:
            a = source.recv(0x1000)
            assert a
            if a:
                b = self.dcmprss.decompress(a)
                self.buffer.append(b)
                if self.state == 0:
                    header = struct.Struct("Q")
                    data = self.buffer.take(header.size)
                    if data:
                        self.hdrlen, = header.unpack(data)
                        print "hdrlen", self.hdrlen
                        self.state = 1
                if self.state == 1:
                    data = self.buffer.take(self.hdrlen)
                    if data:
                        header = eval(data)
                        print header
                        self.length = header["length"]
                        name = header["name"]
                        self.type = header["type"]
                        print self.length, name
                        if os.path.exists(name):
                            root, ext = os.path.splitext(name)
                            self.output = tempfile.NamedTemporaryFile(
                                    delete=False, dir=os.getcwd(), prefix=root+".", suffix=ext)
                        else:
                            self.output = open(name, "w+b")
                        self.name = os.path.basename(self.output.name)
                        self.progress.set_text(self.name)
                        if not self.user_wants_file():
                            self.progress.destroy()
                            del self
                            return False
                        self.state = 2
                if self.state == 2:
                    remaining = self.length - self.output.tell()

                    self.output.write(self.buffer.empty())
                    self.progress.set_fraction(self.output.tell() / self.length)
                return True
        source.close()
        #print "unused data:", self.dcmprss.unused_data
        self.output.write(self.dcmprss.flush())
        print "wrote out", self.output.name
        assert len(self.dcmprss.unused_data) == 0
        assert self.output.tell() == self.length
        self.output.close()
        return False

class FileServer:
    def __init__(self, callback):
        listen_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        if os.name != "nt": listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        if os.name == "nt": listen_socket.setsockopt(socket.SOL_SOCKET, socket.SO_EXCLUSIVEADDRUSE, 1)
        port = 1337
        while True:
            try:
                listen_socket.bind(("", port))
            except socket.error as e:
                if e.errno != errno.EADDRINUSE:
                    raise
                else:
                    port += 1
            else:
                break
        print "listening on", listen_socket.getsockname()
        listen_socket.listen(socket.SOMAXCONN)
        gobject.io_add_watch(listen_socket, gobject.IO_IN, callback)

class MainWindow:
    def drag_data_received(self, widget, drag_context, x, y, selection_data, info, timestamp):
        target = selection_data.target
        data = selection_data.data
        #print target, repr(data)
        assert timestamp in self.best_target
        if target != self.best_target[timestamp]: return
        if target == "text/uri-list":
            uris = data.split("\r\n")
        elif target == "text/plain":
            uris = [data]
        else:
            assert False
        for u in uris:
            if not u or u == "\0": continue
            progbar = gtk.ProgressBar()
            self.vbox.pack_end(progbar)
            FileSend(u, progbar)
    def drop_cb(self, widget, drag_context, x, y, timestamp):
        for a in ("text/uri-list", "text/plain"):
            if a in drag_context.targets:
                assert not timestamp in self.best_target
                self.best_target[timestamp] = a
                break
        for t in drag_context.targets:
            widget.drag_get_data(drag_context, t, timestamp)
        drag_context.finish(True, False, timestamp)
        return True
    def drag_motion(self, widget, drag_context, x, y, timestamp):
        drag_context.drag_status(gtk.gdk.ACTION_COPY, timestamp)
        return True
    def listen_server_cb(self, source, condition):
        assert condition == gobject.IO_IN
        progbar = gtk.ProgressBar()
        progbar.set_orientation(gtk.PROGRESS_RIGHT_TO_LEFT)
        self.vbox.pack_end(progbar)
        a = source.accept()
        FileReceive(a[0], a[1], progbar, self.window)
        return True
    def __init__(self):
        w = gtk.Window()
        #w.set_size_request(100, 50)
        w.set_title("Drop Test Window")
        w.drag_dest_set(0, [], 0)
        w.connect("drag-motion", self.drag_motion)
        w.connect("drag-drop", self.drop_cb)
        w.connect("drag-data-received", self.drag_data_received)
        w.connect("destroy", lambda w: gtk.main_quit())
        scrolled_window = gtk.ScrolledWindow()
        scrolled_window.set_policy(gtk.POLICY_NEVER, gtk.POLICY_AUTOMATIC)
        self.vbox = gtk.VBox()
        scrolled_window.add_with_viewport(self.vbox)
        w.add(scrolled_window)
        #w.add(self.vbox)
        w.show_all()
        FileServer(self.listen_server_cb)
        self.best_target = {}
        self.window = w

MainWindow()
gtk.main()
