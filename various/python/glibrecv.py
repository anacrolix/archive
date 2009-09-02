#!/usr/bin/env python

import gobject
import gtk
import math
import socket
import zlib

class GetFile:
    def __init__(self, conn, address):
        self.output = open(str(address[1]) + ".jpg", "wb")
        self.dcmprss = zlib.decompressobj()
        gobject.io_add_watch(conn, gobject.IO_IN | gobject.IO_HUP, self.event_cb)
    def event_cb(self, source, condition):
        # check only 1 condition is set
        assert not math.modf(math.log(condition, 2))[0]
        if condition & gobject.IO_IN:
            self.output.write(self.dcmprss.decompress(source.recv(0x1000)))
        if condition & ~gobject.IO_IN:
            source.close()
            print "unused data:", self.dcmprss.unused_data
            self.output.write(self.dcmprss.flush())
            assert len(self.dcmprss.unused_data) == 0
            self.output.close()
            print "wrote out", self.output.name
            return False
        else:
            return True

def accept(source, condition):
    GetFile(*source.accept())
    return True

servsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
servsock.bind(("", 1337))
servsock.listen(5)
gobject.io_add_watch(servsock, gobject.IO_IN, accept)
gtk.main()
