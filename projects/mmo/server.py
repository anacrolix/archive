#!/usr/bin/env python

import itertools
import logging
import pdb
import random
import select
import socket

from common import *

def create_server():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(('', 7172))
    s.listen(socket.SOMAXCONN)
    return s

class Entity(object):
    def __init__(self, entid, coords, color):
        self.__entid = entid
        self.__coords = coords
        self.__color = color
    def get_entity_id(self):
        return self.__entid
    def get_coords(self):
        return self.__coords
    def set_coords(self, newval):
        self.__coords = newval
    def get_color(self):
        return self.__color

class Client(Entity):
    def __init__(self, socket, addr, entid):
        super(self.__class__, self).__init__(entid, Coords(random.randrange(15), random.randrange(11)), tuple([random.randrange(i) for i in (0x100,) * 3]))
        self.socket = socket
        self.msgbuf = SocketMessageBuffer(socket)
        self.addr = addr
        self.msgbuf.post_message('loggedin', coords=self.get_coords(), color=self.get_color())
    def pending_out(self):
        return len(self.msgbuf.outbuf) > 0
    def fileno(self):
        return self.socket.fileno()
    def send(self):
        self.msgbuf.send()
    def recv(self):
        return self.msgbuf.recv()
    def post_message(self, *args, **kwargs):
        return self.msgbuf.post_message(*args, **kwargs)

class Server(object):
    def remove_client(self, client):
        self.clients.remove(client)
    def process_message(self, client, title, data):
        if title == 'move':
            #pdb.set_trace()
            newpos = client.get_coords() + DIRECTIONS[data['direction']]
            if newpos.x in range(15) and newpos.y in range(11):
                client.set_coords(newpos)
            client.msgbuf.post_message('moved', coords=client.get_coords())
    def handle_player_messages(self):
        for c in self.iter_clients():
            while True:
                msg = c.msgbuf.get_message()
                if msg:
                    logging.debug("Received message: %s" % str(msg))
                    self.process_message(c, *msg)
                    self.changed = True
                else:
                    break
    def iter_clients(self):
        return map(lambda x: self.entities[x], self.clients)
    def send_entity_info(self):
        for c in self.iter_clients():
            for e in self.entities.values():
                c.post_message('entity', id=e.get_entity_id(), pos=e.get_coords(), color=e.get_color())
    def add_client(self, conn, addr):
        client = Client(conn, addr, self.entidgen.next())
        self.clients.append(client.get_entity_id())
        assert client.get_entity_id() not in self.entities
        self.entities[client.get_entity_id()] = client
        self.changed = True
    def remove_client(self, client):
        logging.info("Disconnected: %s" % str(client.addr))
        entid = client.get_entity_id()
        clients.remove(endid)
        del self.entities[entid]
    def start(self):
        self.server = create_server()
        self.clients = []
        self.entities = {}
        self.entidgen = itertools.count(1)
        while True:
            outgoing = filter(lambda c: c.pending_out(), self.iter_clients())
            ready = select.select([self.server] + self.iter_clients(), outgoing, [])
            #pdb.set_trace()
            for r in ready[0]:
                if r == self.server:
                    logging.debug("Incoming connection")
                    conn, addr = self.server.accept()
                    logging.info("Accepted connection from %s" % str(addr))
                    self.add_client(conn, addr)
                else:
                    r.recv()
            for w in ready[1]:
                w.send()
            self.handle_player_messages()
            if self.changed:
                self.send_entity_info()
                self.changed = False

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    Server().start()
