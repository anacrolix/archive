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

def str_count(keywords, buffer):
    hits = 0
    for kw in keywords:
        hits += buffer.count(kw)
    return hits

def re_count(keywords, buffer):
    """This does not work as intended, I think it returns one match where there could be several"""
    import re
    hits = 0
    pattern = "|".join([re.escape(kw) for kw in keywords])
    for match in re.finditer(pattern, buffer):
        hits += len(match.groups())
    return hits

if __name__ == "__main__":
    buffer = open("reuters21578/reut2-000.sgm", "rb").read()
    start = time.time()
    print re_count(keywords, buffer)
    print time.time() - start
