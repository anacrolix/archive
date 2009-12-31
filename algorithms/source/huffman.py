#!/usr/bin/env python

import pdb
import sys
from heapq import heapify, heappop, heappush
from collections import namedtuple
from bitarray import bitarray
from StringIO import StringIO

class SymbolWeights(object):
    def __init__(self, symbol_bits=8):
        self.frequencies = {}
        self.symbol_bits = symbol_bits
    def __invariant(self):
        for a in self.frequencies.keys():
            assert a.length() == self.symbol_bits
    def add_symbols(self, more_symbols):
        #pdb.set_trace()
        assert not len(more_symbols) % self.symbol_bits
        for index in xrange(0, len(more_symbols), self.symbol_bits):
            symbol = more_symbols[index:index+self.symbol_bits]
            if not self.frequencies.has_key(symbol):
                self.frequencies[symbol] = 0
            self.frequencies[symbol] += 1
        self.__invariant()
    def __iter__(self):
        return self.frequencies.iteritems()
    def __str__(self):
        s = StringIO()
        print >>s, self.symbol_bits
        for a in self.frequencies.iteritems():
            print >>s, a
        return s.getvalue()

def encode(weights, input):
    #weights = {}
    #for c in set(text):
        #weights[c] = text.count(c)
    forest = [ [w, (s, bitarray())] for s, w in weights ]
    heapify(forest)
    #print forest
    while len(forest) > 1:
        left = heappop(forest)
        for i in left[1:]: i[1].insert(0, False)
        right = heappop(forest)
        for i in right[1:]: i[1].insert(0, True)
        parent = [left[0] + right[0]] + left[1:] + right[1:]
        heappush(forest, parent)
    huffman = dict(heappop(forest)[1:])
    print huffman
    output = bitarray(endian="little")
    text = bitarray()
    text.fromfile(input)
    for index in xrange(0, len(text),
    output.encode(huffman, text)
    #print output, len(output)
    return huffman, output

def encode_file(input_file, output_file):
    weights = SymbolWeights()
    while True:
        buffer = input_file.read(512)
        if not buffer: break
        a = bitarray()
        a.fromstring(buffer)
        weights.add_symbols(a)
    print weights
    input_file.seek(0)
    code, huffed = encode(weights, input_file)
    output_file.write(repr(code) + "\n")
    output_file.write(str(huffed.buffer_info()[3]))
    huffed.tofile(output_file)
    original_size = len(unhuffed)
    huffed_size = output_file.tell()
    print "compression:", 100.0 * huffed_size / original_size
    output_file.flush()

def decode_file(input_file, output_file):
    huffman_code = eval(input_file.readline())
    unused = int(input_file.read(1))
    encoded_text = bitarray(endian="little")
    encoded_text.fromfile(input_file)
    if unused: del encoded_text[-unused:]
    output_file.write("".join(encoded_text.decode(huffman_code)))

if __name__ == "__main__":
    target = sys.argv[1]
    encode_file(open(target, "rb"), open(target + ".huff", "wb"))
    decode_file(open(target + ".huff", "rb"), open(target + ".unhuffed", "wb"))
