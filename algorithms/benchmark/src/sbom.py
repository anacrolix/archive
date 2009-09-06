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
def for_all_nodes(toplevel):
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
    #print patterns
    trie = build_trie(patterns)
    trie.append(None)
    for parent, symbol, current in transverse_order(trie):
        #assert len(current) == 2
        if len(current) == 2: current.append(None)
        down = parent[2]
        while down != None and not down[0].has_key(symbol):
            down[0][symbol] = current
            down = down[2]
        if down != None:
            #if down[0].has_key(symbol):
            current[2] = down[0][symbol]
            #else:
            #current.append(None)
        else:
            current[2] = trie
    return trie

# each node is [
        #{symbols: nodes},
        #set(outputs), (not needed? only contains 1 output for all cases i can predict)
        #supply node, (not used after oracle generation?)
        #patterns with the prefix of this node if it's terminal
    #]

class SBOM(object):
    def __init__(self, patterns):
        self.lmin = min(map(len, patterns))
        #print lmin
        self.oracle = build_oracle_multiple([p[self.lmin-1::-1] for p in patterns])
        #pdb.set_trace()
        #print sum(1 for i in for_all_nodes(self.oracle))
        #print len(for_all_nodes(self.oracle))
        #pdb.set_trace()
        #print self.oracle
        for n in for_all_nodes(self.oracle):
            assert len(n) == 3
            n.append(set())
        for p in patterns:
            q = self.oracle
            for s in p[self.lmin-1::-1]:
                q = q[0][s]
            assert len(q) == 4
            q[3].add(p)
        self.shifts = []

    @staticmethod
    def print_hit(position, pattern):
        print str(position) + ":", repr(pattern)

    def __call__(self, text, hit_cb=None):
        if hit_cb == None: hit_cb = self.print_hit
        #pdb.set_trace()
        pos = 0
        while pos <= len(text) - self.lmin:
            #print pos,
            #if pos == 17: pdb.set_trace()
            current = self.oracle
            j = self.lmin
            while j >= 1 and current != None:
                #print text[pos + j - 1],
                if current[0].has_key(text[pos + j -1]):
                    current = current[0][text[pos + j -1]]
                else:
                    current = None
                j -= 1
            if current != None and j == 0:
                #pdb.set_trace()
                assert len(current[1]) == 1
                if text[pos:pos+self.lmin] == list(current[1])[0][::-1]:
                    for p in current[3]:
                        assert text[pos:pos+self.lmin] == p[:self.lmin]
                        if text[pos+self.lmin:pos+len(p)] == p[self.lmin:]:
                            #print
                            hit_cb(pos, p)
                    #print current[3]
                    #j = 0
                else:
                    # this proves that trie-F is not actually required anymore
                    assert False
            pos += j + 1
            self.shifts.append(j + 1)
            #print

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

