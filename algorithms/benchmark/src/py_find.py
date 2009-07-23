#!/usr/bin/env python

keywords = []
for a in ("exchanges", "orgs", "people", "places", "topics"):
    for kw in open("reuters21578/all-" + a + "-strings.lc.txt"):
        #kw = kw.rstrip()
        if len(kw): keywords.append(kw[:-1])

#print keywords
assert len(keywords) == 672

import time

def blah():
    buffer = open("reuters21578/reut2-000.sgm", "rb").read()
    hits = 0
    for kw in keywords:
        start = -1
        while True:
            start = buffer.find(kw, start + 1)
            if start == -1: break
            else: hits += 1
    print hits

start = time.time()
blah()
print time.time() - start
