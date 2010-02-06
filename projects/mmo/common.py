import collections
import pdb
import select
import socket

__all__ = ["DIRECTIONS", "Coords", "SocketMessageBuffer", "Disconnected"]

DIRECTIONS = {
        'north': (0, -1),
        'east': (1, 0),
        'south': (0, 1),
        'west': (-1, 0),}

Message = collections.namedtuple("Message", ("title", "data"))

class Disconnected(Exception):
    pass

class Coords(object):
    def __init__(self, x, y):
        self.x = x
        self.y = y
    def __iter__(self):
        yield self.x
        yield self.y
    #def __add__(self, other):

    #def __iadd__(self, other):
        #self.x += other[0]
        #self.y += other[1]
        #assert len(other) == 2
        #return self
    def __add__(self, other):
        assert len(other) == 2
        return Coords(self.x + other[0], self.y + other[1])
    def __repr__(self):
        return "Coords(x=%r, y=%r)" % (self.x, self.y)

class SocketMessageBuffer(object):
    def __init__(self, socket):
        self.inbuf = ""
        self.outbuf = ""
        self.socket = socket
    def post_message(self, title, **data):
        #assert "\x00" not in data
        self.outbuf += repr((title, data)) + "\x00"
    def get_message(self):
        try:
            index = self.inbuf.index("\x00")
        except ValueError:
            return
        data = self.inbuf[:index]
        self.inbuf = self.inbuf[index+1:]
        return Message(*eval(data))
    def flush(self):
        """DOES NOT BLOCK"""
        ready = select.select([self.socket], [self.socket], [], 0)
        #pdb.set_trace()
        if ready[0]:
            if not self.recv(False):
                #assert not ready[1]
                return False
        if ready[1]:
            self.send(False)
        return True
    def send(self, ready=True):
        sent = self.socket.send(self.outbuf)
        assert not ready or sent != 0
        self.outbuf = self.outbuf[sent:]
    def recv(self, ready=True):
        data = self.socket.recv(0x1000)
        if not data:
            raise Disconnected()
        self.inbuf += data
        return len(data) > 0
