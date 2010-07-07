#!/usr/bin/env python

class Lanshare(object):

    __version__ = "0.2"
    __program__ = "Lanshare"
    __title__ = "{0} v{1}".format(__program__, __version__)
    __author__ = "Matt Joiner <anacrolix@gmail.com>"

    __slots__ = "server", "config", "port"

    def __init__(self):
        object.__init__(self)

        from optparse import OptionParser
        parser = OptionParser()
        parser.add_option("--secure", default=False, action="store_true",
                help="Require explicit TLS on command and data connections")
        parser.add_option("--port", default=1337, action="store", type="int",
                help="Set the {0} FTP port".format(self.__program__))
        options, posargs = parser.parse_args()
        #print options, posargs

        from config import Config
        config = Config()

        from pyftpdlib import ftpserver
        if options.secure:
            from pyftpdlib.contrib.handlers import TLS_FTPHandler as handler
            handler.tls_control_required = True
            handler.certfile = "wotevs.pem"
        else:
            handler = ftpserver.FTPHandler
        handler.banner = "{0} ready".format(self.__title__)
        from filesys import LanshareFS
        LanshareFS.shares = config.shares
        handler.abstracted_fs = LanshareFS
        authorizer = ftpserver.DummyAuthorizer()
        authorizer.add_anonymous(homedir=None)
        handler.authorizer = authorizer
        import socket
        server = ftpserver.FTPServer(("0.0.0.0", options.port), handler)
        print "FTP server listening on {0}".format(server.socket.getsockname())

        self.server = server
        self.config = config
        self.port = options.port

    def __call__(self):
        self.server.serve_forever()

def main():
    Lanshare()()

if __name__ == "__main__":
    main()
