#!/usr/bin/env python3

class Horspool:
    def __init__(self, pattern):
        self.m = len(pattern)
        self.d = {}
        for j in range(1, self.m):
            self.d[pattern[j - 1]] = self.m - j
        self.p = pattern
    def __call__(self, text, report):
        pos = 0
        while pos <= len(text) - self.m:
            j = self.m
            while j > 0 and text[pos + j - 1] == self.p[j - 1]:
                j -= 1
            if j == 0 and report(pos + 1): return
            pos += self.d.get(text[pos + self.m - 1], self.m)

from unittest import TestCase, main

class HorspoolTest(TestCase):
    def testEnglish(self):
        actual = []
        Horspool("announce")("CPM_annual_conference_announce", actual.append)
        self.assertSequenceEqual(actual, [23])
    def testDNA(self):
        actual = []
        Horspool("ATATA")("AGATACGATATATAC", actual.append)
        self.assertSequenceEqual(actual, [8, 10])
    def testReturnEarly(self):
        actual = []
        def first(pos):
            actual.append(pos)
            return True
        Horspool("ATATA")("AGATACGATATATAC", first)
        self.assertSequenceEqual(actual, [8])

if __name__ == "__main__":
    main()
