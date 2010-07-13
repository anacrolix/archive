#!/usr/bin/env python

import BaseHTTPServer
import logging
import optparse
import sys

import pages

class TibstatsHTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):

    def do_GET(self):
        self.process_request()

    def do_POST(self):
        self.process_request()

    def do_HEAD(self):
        self.send_error(418, "Short and stout")

    def process_request(self):
        pages.handle_http_request(self)

    # maybe want to hook the internal request logging mechanism?
    #def log_message(self, format, *posargs):
    #    logging.info(format, *posargs)

def main():
    parser = optparse.OptionParser()
    parser.add_option("-p", "--port", type="int", default=17091)
    opts, args = parser.parse_args()
    logging.basicConfig(level=logging.DEBUG)
    server_class = BaseHTTPServer.HTTPServer
    handler_class = TibstatsHTTPRequestHandler
    server_address = ("", opts.port)
    logging.info("Starting server on %s", server_address)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    main()
