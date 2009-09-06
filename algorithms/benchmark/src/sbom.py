#!/usr/bin/env python

from __future__ import division
import pdb
import sys
import unittest # really sux

#
# GENERIC ALGORITHM STUFF
#

def build_trie(patterns):
    """Generates a trie of [{symbols: nodes}, set(outputs)]"""
    trie = [{}, set()]
    for p in patterns:
        current = trie
        j = 0
        while j < len(p) and p[j] in current[0]:
            current = current[0][p[j]]
            j += 1
        while j < len(p):
            state = [{}, set()]
            assert not current[0].has_key(p[j])
            current[0][p[j]] = state
            current = state
            j += 1
        current[1].add(p)
    return trie

# does not yield the first parent, perhaps i could, and have it's parent None?
def transverse_order(parent):
    #children = parent[0].values()
    for symbol, child in parent[0].iteritems():
        yield parent, symbol, child
    for child in parent[0].values():
        for transition in transverse_order(child):
            yield transition

# is there a better way to do this?
# i've tried to avoid recursive visited sets
def unique_nodes(toplevel):
    def visit_node(parent):
        if parent not in visited:
            yield parent
            visited.append(parent)
            for child in parent[0].values():
                for node in visit_node(child):
                    yield node
    visited = []
    for node in visit_node(toplevel):
        yield node

#
# SET BACKWARD ORACLE MATCHER
#

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
        self.lmin = min(map(len, patterns))
        # there must be a better way to reverse a string!?
        self.oracle = build_oracle_multiple([p[self.lmin-1::-1] for p in patterns])
        for n in unique_nodes(self.oracle):
            assert len(n) == 1
            n.append(set())
        for p in patterns:
            q = self.oracle
            # walk the prefix path
            for s in p[self.lmin-1::-1]:
                q = q[0][s]
            # this is max depth in an SBOM tree
            assert len(q[0]) == 0
            assert len(q) == 2
            q[1].add(p)
        #self.shifts = []
        #print "lmin:", self.lmin, "len(nodes):", self.node_count(), "len(patterns)", len(patterns)

    def node_count(self):
        return sum(1 for i in unique_nodes(self.oracle))

    @staticmethod
    def print_hit(position, pattern):
        print str(position) + ":", repr(pattern)

    def __call__(self, text, hit_cb=None):
        if hit_cb == None: hit_cb = self.print_hit
        pos = 0
        while pos <= len(text) - self.lmin:
            current = self.oracle
            j = self.lmin - 1
            while j >= 0 and current != None:
                current = current[0].get(text[pos + j], None)
                j -= 1
            if j == -1 and current != None:
                for p in current[1]:
                    if text[pos+self.lmin:pos+len(p)] == p[self.lmin:]:
                        hit_cb(pos, p)
            pos += j + 2

#
# UNIT TESTS
#

sys.path.append(".")
import reuters

class SearchAlgorithmTest(object):
    CORRECTNESS_TESTS = (
            ("CPM", {"announce": [22], "annual": [4], "annually": []}, "CPM_annual_conference_announce"),
            ("DNA", {"ATATATA": [7], "TATAT": [8], "ACGATAT": [4]}, "AGATACGATATATAC"),)
    def correctness_cb(self, position, pattern):
        self.results[pattern].append(position)
    def testCorrectness(self):
        for a in self.CORRECTNESS_TESTS:
            self.results = dict([(k, []) for k in a[1].keys()])
            machine = self.algorithm(a[1].keys())
            machine(a[2], self.correctness_cb)
            self.assertEqual(a[1], self.results)
    def reuters_cb(self, position, pattern):
        self.hits += 1
    def testReuters(self):
        machine = SBOM(reuters.get_keywords())
        self.hits = 0
        machine(reuters.get_data_files()[0].read(), self.reuters_cb)
        self.assertEqual(16193, self.hits)

class SBOM_TestCase(unittest.TestCase, SearchAlgorithmTest):
    algorithm = SBOM

if __name__ == "__main__":
    unittest.main()

