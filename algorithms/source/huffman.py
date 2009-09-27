#!/usr/bin/env python

import pdb
import sys
from heapq import heapify, heappop, heappush
from collections import namedtuple
from bitarray import bitarray

class SymbolFrequencies(object):
    def __init__(self):
        self.weights = {}
    def weigh(self, sample):
        for a in set(sample):
            if a not in self.weights:
                self.weights[a] = 0
            self.weights[a] += sample.count(a)
        return self
    def __str__(self):
        r = ""
        for a in sorted((b for b in self.weights.iteritems()), key=lambda c: c[1], reverse=True):
            r += repr(a) + "\n"
        return r

class Leaf(object):
    def __init__(self, symbol):
        self.symbol = symbol

class Branch(object):
    def __init__(self, left, right):
        self.left = left
        self.right = right

def build_encoder(tree):
    #pdb.set_trace()
    def visit(node, path):
        if isinstance(node, Leaf):
            symbol = node.symbol
            assert symbol not in encoder
            encoder[symbol] = path
        elif isinstance(node, Branch):
            visit(node.left, path + "0")
            visit(node.right, path + "1")
        else:
            raise TypeError
    encoder = {}
    visit(tree, bitarray())
    return encoder

class HuffmanTree(object):
    def __init__(self, symbol_weights):
        forest = [ (weight, Leaf(symbol)) for symbol, weight in symbol_weights.iteritems() ]
        #print forest
        heapify(forest)
        while len(forest) > 1:
            left = heappop(forest)
            right = heappop(forest)
            #for i in left[1:]: i[1].insert(0, '0')
            #for i in right[1:]: i[1].insert(0, '1')
            parent = (left[0] + right[0], Branch(left[1], right[1]))
            #parent = [ left[0] + right[0] ] + left[1:] + right[1:]
            heappush(forest, parent)
        assert len(forest) == 1
        self.decoder = heappop(forest)[1]
        #print self.decoder
        self.encoder = build_encoder(self.decoder)
    def encode(self, text):
        encoded_text = bitarray()
        encoded_text.encode(self.encoder, text)
        print encoded_text.length()
        return encoded_text.tostring()
    def decode(self, text):
        a = bitarray()
        a.fromstring(text)
        print a
        return a.decode(self.encoder)

def show_huffman_codes(text):
    a = SymbolFrequencies()
    a.weigh(text)
    print a
    b = HuffmanTree(a.weights)
    print b.encoder
    for c in b.encoder.iteritems():
        print "%s\t%s" % (c[0], c[1])
    encoded_text = b.encode(text)
    print repr(encoded_text), len(encoded_text)
    print "original length:", 8 * len(text)
    decoded_text = "".join(b.decode(encoded_text))
    print decoded_text
    assert decoded_text == text

if __name__ == "__main__":
    #show_huffman_codes("matt")
    #show_huffman_codes("This is a realllllllly long sentence!")
    #show_huffman_codes(open(sys.argv[0]).read())
    #show_huffman_codes(open("treeops.pyc").read())
    show_huffman_codes("this is an example for huffman encoding")

