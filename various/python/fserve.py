#!/usr/bin/env python

from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from os import listdir
import os.path
#import gzip
import cStringIO
#import mimetypes
import zlib
import urllib
import miniupnpc
import bz2

class handler_class(BaseHTTPRequestHandler):
    def do_GET(self):
        #self.send_response(200)
        #self.end_headers()
        print self.headers
        print self.server
        print self.client_address
        print self.path
        full_path = os.path.join("serves", urllib.url2pathname(self.path[1:]))
        print full_path
        #import pdb
        #pdb.set_trace()
        if os.path.isdir(full_path):
            self.wfile.write("<html>")
            for targ in listdir(full_path):
                self.wfile.write('<a href="%s">%s</a><br>' % (urllib.pathname2url(os.path.join(self.path, targ)), targ))
            self.wfile.write("</html>")
        elif os.path.isfile(full_path):
            self.send_response(200)
            print "sending file"
            self.send_header("Content-Encoding", "deflate")
            #zbuf = cStringIO.StringIO()
            #zfile = zfile = gzip.GzipFile(mode='wb', fileobj=zbuf, compresslevel=9)
            #zfile.write(open(full_path, "rb").read())
            #zfile.close()
            #data = zbuf.getvalue()
            print "compressign"
            self.end_headers()
            compressor = zlib.compressobj()
            input_file = open(full_path, "rb")
            while True:
                input_data = input_file.read(0x2000)
                if input_data:
                    self.wfile.write(compressor.compress(input_data))
                else:
                    self.wfile.write(compressor.flush())
                    break
            #print "orig size:", os.path.getsize(full_path), "compressed:", len(data)
            #type, encoding = mimetypes.guess_type(full_path)
            #print repr(data)
            #print repr(data)
            #self.send_header("Content-Type", type)
            #self.send_header("Content-Length", len(data))
            #self.wfile.write(data)

httpd = HTTPServer(('', 3000), handler_class)

upnp = miniupnpc.UPnP()
print upnp.discoverdelay
upnp.discoverdelay = 200
print upnp.discover()
upnp.selectigd()
#import pdb
#pdb.set_trace()
assert upnp.addportmapping(1337, 'TCP', upnp.lanaddr, httpd.server_port, "porn server", '')

httpd.serve_forever()
