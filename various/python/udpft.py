#!/usr/bin/env python

import binascii
import hashlib
import io
import os.path
import pdb
import select
import socket
import struct
import sys
import time

class Hasher():
    def __init__(self, initial=None):
        self.__hash = hashlib.md5()
        if initial != None:
            if hasattr(initial, "read"):
                self.update_from(initial)
            else:
                self.update(initial)
    def update_from(self, fileobj):
        while True:
            buffer = fileobj.read(0x2000)
            self.update(buffer)
            if not buffer: break
    def __getattr__(self, name):
        return getattr(self.__hash, name)
    #@property
    #def digest_size(self):
    #    return self.__hash.digest_size

DIGESTSIZE = Hasher().digest_size
PORT = 1337
RECVBUFSIZE = 0x10000 # ~65k, tweak this later
CHUNKSIZE = 512
#TAG = "UDPFT"
#BROADCAST = 1

class Packet(object):
    __IDENT = "UDPFT"
    __HEADER = struct.Struct("!%dsH" % (len(__IDENT),))
    assert __HEADER.size == 7
    TYPE_OFFER = 1
    TYPE_REQUEST = 2
    @classmethod
    def from_bytes(class_, bytes):
        ident, type = class_.__HEADER.unpack(bytes[:class_.__HEADER.size])
        if ident != class_.__IDENT: return
        return {
                class_.TYPE_OFFER: OfferPacket,
                class_.TYPE_REQUEST: RequestPacket,
            }[type].from_bytes(bytes[class_.__HEADER.size:])
    def __init__(self, type):
        self.type = type
    def to_bytes(self):
        return self.__HEADER.pack(self.__IDENT, self.type)

class OfferPacket(Packet):
    __HEADER = struct.Struct("!%dsQ" % (DIGESTSIZE,))
    @classmethod
    def from_bytes(class_, bytes):
        digest, filesize = class_.__HEADER.unpack(bytes[:class_.__HEADER.size])
        filename = bytes[class_.__HEADER.size:]
        return class_(digest, filesize, filename)
    def __init__(self, digest, filesize, filename):
        Packet.__init__(self, Packet.TYPE_OFFER)
        self.digest = digest
        self.filesize = filesize
        self.filename = filename
    def to_bytes(self):
        #pdb.set_trace()
        return  super(self.__class__, self).to_bytes() \
                + self.__HEADER.pack(self.digest, self.filesize) + self.filename
    def __repr__(self):
        return "<%s filename=%s, filesize=%u, digest=%s>" % (
                self.__class__.__name__, self.filename, self.filesize, binascii.hexlify(self.digest))

class RequestPacket(Packet):
    __HEADER = struct.Struct("!%ds" % (DIGESTSIZE,))
    __OFFSET_FIELD = struct.Struct("!I")
    def __init__(self, digest, offsets):
        Packet.__init__(self, Packet.TYPE_REQUEST)
        self.digest = digest
        self.offsets = offsets
    def to_bytes(self):
        packet = super(self.__class__, self).to_bytes()
        packet += self.__HEADER.pack(self.digest)
        for o in self.offsets:
            packet += self.__OFFSET_FIELD.pack(o)
        return packet
    @classmethod
    def from_bytes(class_, bytes):
        #pdb.set_trace()
        digest = class_.__HEADER.unpack(bytes[:class_.__HEADER.size])
        offsets = []
        bytes = bytes[class_.__HEADER.size:]
        while True:
            try:
                offsets.append(class_.__OFFSET_FIELD.unpack(bytes[:class_.__OFFSET_FIELD.size]))
            except struct.error:
                #pdb.set_trace()
                assert len(bytes) == 0
                break
            bytes = bytes[class_.__OFFSET_FIELD.size:]
        return class_(digest, offsets)

def listen():
    """Listen for offers from any sender."""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind(('', PORT))
    offers = set()
    while True:
        data, address = s.recvfrom(0x10000)
        packet = Packet.from_bytes(data)
        if isinstance(packet, OfferPacket):
            print packet

class SendOffer:
    def __init__(self, filepath):
        self.fileobj = open(filepath, "rb")
        self.digest = Hasher(self.fileobj).digest()
        assert self.fileobj.tell() == os.path.getsize(filepath)
        self.filesize = self.fileobj.tell()
        assert not os.path.isabs(filepath)
        self.filepath = filepath
        self.packet = OfferPacket(self.digest, self.filesize, self.filepath).to_bytes()
    def __repr__(self):
        return "<Offer digest=%s, size=%u, filepath=%s>" \
                % (binascii.hexlify(self.digest), self.filesize, self.filepath)

def offer(recipient, paths):
    """Offer the specified paths to the recipient address."""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    s.bind(('', 0))
    #port = s.getsockname()[1]
    offers = []
    for p in paths:
        if not os.path.isdir(p):
            offers.append(SendOffer(p))
    print offers
    assert len(offers) > 0
    while True:
        s.settimeout(None)
        for o in offers:
            #packet = Broadcast(o.digest, o.filesize, o.filepath).to_bytes()
            print repr(o.packet)
            s.sendto(o.packet, (recipient, PORT))
        next_offer = time.time() + 1.0
        while True:
            time_left = next_offer - time.time()
            if time_left < 0.0: break
            s.settimeout(next_offer - time.time())
            try:
                data, address = s.recvfrom(RECVBUFSIZE)
            except socket.timeout:
                break
            else:
                print repr(data)
                packet = Packet.from_bytes(data)
                assert isinstance(packet, RequestPacket)

def divceil(a, b):
    q, r = divmod(a, b)
    return q + r and 1

def receive(digests):
    """Listen for offers of the given digests, request them, and write them out."""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind(('', PORT))
    offers = {}
    while True:
        try:
            next_request = time.time() + 1.0
            while True:
                s.settimeout(next_request - time.time())
                data, address = s.recvfrom(RECVBUFSIZE)
                packet = Packet.from_bytes(data)
                if isinstance(packet, OfferPacket):
                    if packet.digest in digests:
                        if not packet.digest in offers:
                            print "received new file digest: %s (%u bytes)" % (
                                    binascii.hexlify(packet.digest), packet.filesize)
                            offers[packet.digest] = (
                                    set(),
                                    packet.filesize,
                                    set(xrange(divceil(packet.filesize, CHUNKSIZE))),
                                    open(binascii.hexlify(packet.digest), "w+b"))
                        new_offer = (address, packet.filename)
                        assert packet.filesize == offers[packet.digest][1]
                        if not new_offer in offers[packet.digest][0]:
                            print "new offer for %s from %s named %s" % (
                                    binascii.hexlify(packet.digest), address, packet.filename)
                            offers[packet.digest][0].add(new_offer)
        except socket.timeout:
            s.settimeout(None)
            for digest, details in offers.iteritems():
                for offer in details[0]:
                    packet = RequestPacket(digest, details[2]).to_bytes()
                    print repr(packet)
                    s.sendto(packet, offer[0])

        #elif isinstance(packet,

if __name__ == "__main__":
    if sys.argv[1] == "send":
        offer(sys.argv[2], sys.argv[3:])
    elif sys.argv[1] == "listen":
        listen()
    elif sys.argv[1] == "receive":
        receive(map(binascii.unhexlify, sys.argv[2:]))
    elif sys.argv[1] == "broadcast":
        offer("<broadcast>", sys.argv[2:])
    else: sys.exit("unknown command: " + sys.argv[1])
