#!/usr/bin/env python

#import itertools
#import pdb
import reuters
import sys
import time

assert __name__ == "__main__"

class SinglePatternSearcher(object):
    def __init__(self, algorithm):
        self.algorithm = algorithm
    def initialize(self, patterns):
        self.machines = []
        for p in patterns:
            self.machines.append(self.algorithm(p))
    def __call__(self, text, report):
        for i, m in enumerate(self.machines):
            m(text, lambda p: report(i, p))

class MultiPatternSearcher(object):
    def __init__(self, algorithm):
        self.algorithm = algorithm
    def initialize(self, patterns):
        self.machine = self.algorithm(patterns)
    def __call__(self, text, report):
        self.machine(text, report)

sys.path.append("../source")
import ahosick
import sbom
import horspool
import strfind
SEARCH_ALGORITHMS = {
        "AhoCorasick": (ahosick.AhoCorasick, MultiPatternSearcher),
        "Horspool": (horspool.CHorspool, SinglePatternSearcher),
        "SBOM": (sbom.SBOM, MultiPatternSearcher),
        "str.find": (strfind.StrFind, SinglePatternSearcher),
    }

class TestCase(object):
    def print_start(self, algname):
        lmin = min(map(len, self.patterns)) if len(self.patterns) != 0 else 0
        print "%s - %s (%i bytes, %i patterns, lmin=%i)" % \
                (self.name, algname, len(self.text), len(self.patterns), lmin),

class CorrectnessTestCase(TestCase):
    def __init__(self, name, human, text):
        self.name = name
        self.patterns = []
        self.expected = []
        for pattern, expected in human.iteritems():
            self.patterns.append(pattern)
            self.expected.append(set(expected))
        self.text = text
    def __call__(self, algname, searcher):
        self.print_start(algname)
        #print algname, "-", self.name, "...",
        searcher.initialize(self.patterns)
        results = [set() for i in self.patterns]
        #for p in self.patterns:
        #    results.append(set())
        def callback(which, where):
            results[which].add(where)
        start = time.time()
        #pdb.set_trace()
        searcher(self.text, callback)
        duration = time.time() - start
        if results != self.expected:
            print
            print "Expected:", self.expected
            print "Actual:  ", results
            print "FAILED",
        else:
            print "PASSED",
        print "(%.2fs)" % (duration,)

class ReutersTestCase(TestCase):
    def __init__(self, files=None, morphs=None, lmin=1):
        self.name = "Reuters Performance"

        c = reuters.get_keywords()
        d = set()
        for a in c:
            if len(a) >= lmin: d.add(a)
            for b in morphs or []:
                e = b(a)
                if len(e) >= lmin: d.add(e)
        print len(d)
        self.patterns = list(d)

        c = ""
        a = reuters.get_data_files()
        for b in files or [0]:
            c += a[b].read()
        self.text = c
    def __call__(self, algname, searcher):
        self.print_start(algname)
        searcher.initialize(self.patterns)
        hit_count = [0]
        def callback(which, where):
            hit_count[0] += 1
        start = time.time()
        searcher(self.text, callback)
        duration = time.time() - start
        print hit_count, duration

CORRECTNESS_TESTCASES = [CorrectnessTestCase(*a) for a in [
        ["CPM_full", {"announce": [22], "annual": [4], "annually": []}, "CPM_annual_conference_announce"],
        ["Matt", {"yoyo": [31], "yo": [7, 11, 31, 33], "Yo": [0], "oh": [4]}, "Yo, oh yo, you know Matt got a yoyo?"],
        ["DNA", {"ATATATA": [7], "TATAT": [8], "ACGATAT": [4]}, "AGATACGATATATAC"],
        ["Empty", {}, ""],
        ["NoText", {"Not": [], "There": []}, ""],
        ["NoPatterns", {}, "Hello World"],
        ["Small", {"a": [0]}, "a"],
        ["ushers", {"he": [2], "she": [1], "his": [], "hers": [2]}, "ushers"],
    ]]

for testcase in CORRECTNESS_TESTCASES:
    for algname, searchgen in SEARCH_ALGORITHMS.iteritems():
        testcase(algname, searchgen[1](searchgen[0]))

for algname, searchgen in SEARCH_ALGORITHMS.iteritems():
    ReutersTestCase(files=xrange(1), lmin=5)(algname, searchgen[1](searchgen[0]))
