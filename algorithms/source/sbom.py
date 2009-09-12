from __future__ import division
#import psyco
import sys

from treeops import *

def build_oracle_multiple(patterns):
    for p in patterns[1:]:
        assert len(p) == len(patterns[0])
    trie = build_trie(patterns)
    for node in unique_nodes(trie):
        assert len(node) == 2
        node[1] = None # we drop output for down
    for parent, symbol, current in transverse_order(trie):
        down = parent[1]
        while down != None and not down[0].has_key(symbol):
            down[0][symbol] = current
            down = down[1]
        if down != None:
            current[1] = down[0][symbol]
        else:
            current[1] = trie
    for node in unique_nodes(trie):
        assert len(node) == 2
        node[:] = node[0:1]
    return trie

# each node is [
        #{symbols: nodes},
        #patterns with the prefix of this node if it's terminal
    #]

class SBOM(object):
    def __init__(self, patterns):
        self.lmin = min(map(len, patterns)) if len(patterns) > 0 else 0
        # there must be a better way to reverse a string!?
        self.oracle = build_oracle_multiple([p[self.lmin-1::-1] for p in patterns])
        for n in unique_nodes(self.oracle):
            assert len(n) == 1
            n.append(set())
        for i, p in enumerate(patterns):
            q = self.oracle
            # walk the prefix path
            for s in p[self.lmin-1::-1]:
                q = q[0][s]
            # this is max depth in an SBOM tree
            # i wonder why this is invalid for larger lmins... maybe i've missed something
            #assert len(q[0]) == 0
            assert len(q) == 2
            q[1].add((i, p[self.lmin:]))
        #self.shifts = []
        #print "lmin:", self.lmin, "len(nodes):", self.node_count(), "len(patterns)", len(patterns)

    def node_count(self):
        return sum(1 for i in unique_nodes(self.oracle))

    @staticmethod
    def print_hit(position, pattern):
        print str(position) + ":", repr(pattern)

    #@psyco.proxy
    def __call__(self, text, hit_cb=None):
        if hit_cb == None: hit_cb = self.print_hit
        pos = 0
        stop = len(text) - self.lmin
        while pos <= stop:
            current = self.oracle
            j = self.lmin - 1
            while j >= 0 and current != None:
                symbol = text[pos + j]
                if current[0].has_key(symbol):
                    current = current[0][symbol]
                else:
                    current = None
                #current = current[0].get(text[pos + j], None)
                j -= 1
            if j == -1 and current != None:
                for which, tail in current[1]:
                    start = pos + self.lmin
                    if text[start:start+len(tail)] == tail:
                        hit_cb(which, pos)
            pos += j + 2
