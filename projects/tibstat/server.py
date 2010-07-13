#!/usr/bin/env python

import BaseHTTPServer, sys

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

def main(
        server_class=BaseHTTPServer.HTTPServer,
        handler_class=TibstatsHTTPRequestHandler):
    try:
        port = int(sys.argv[sys.argv.index("-p") + 1])
    except ValueError:
        port = 80
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    main()
