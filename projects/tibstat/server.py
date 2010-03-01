#!/usr/bin/env python

import BaseHTTPServer

import pages

class TibstatsHTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):

    def do_GET(self):
        self.process_request()

    def do_POST(self):
        self.process_request()

    def process_request(self):
        pages.handle_http_request(self)

    def get_selected_world(self):
        return self.query.get("world", (None,))[0]

def main(
        server_class=BaseHTTPServer.HTTPServer,
        handler_class=TibstatsHTTPRequestHandler):
    server_address = ('', 17021)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    main()
