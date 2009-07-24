#!/usr/bin/env python

keywords = []
for a in ("exchanges", "orgs", "people", "places", "topics"):
    for kw in open("reuters21578/all-" + a + "-strings.lc.txt"):
        #kw = kw.rstrip()
        if len(kw): keywords.append(kw[:-1])

#print keywords
assert len(keywords) == 672

import time

def strfind(keywords, buffer):
    hits = 0
    for kw in keywords:
        start = -1
        while True:
            start = buffer.find(kw, start + 1)
            if start == -1: break
            else: hits += 1
    return hits

def blah():
    buffer = open("reuters21578/reut2-000.sgm", "rb").read()
    print strfind(keywords, buffer)

if __name__ == "__main__":
    start = time.time()
    blah()
    print time.time() - start
