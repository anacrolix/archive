#!/usr/bin/env python

import BaseHTTPServer, Cookie, urlparse, itertools, io, os, pdb, shutil, sys, time

import pages

class TibstatsHTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):

    def do_GET(self):
        self.process_request()

    def do_POST(self):
        self.process_request()

    def process_request(self):
        pages.generate_http_response(self)

def main(server_class=BaseHTTPServer.HTTPServer,
        handler_class=TibstatsHTTPRequestHandler):
    server_address = ('', 17021)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    main()
