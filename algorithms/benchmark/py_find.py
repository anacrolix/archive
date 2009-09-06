#!/usr/bin/env python

def get_keywords():
    r = set()
    for a in ("exchanges", "orgs", "people", "places", "topics"):
        for kw in open("reuters21578/all-" + a + "-strings.lc.txt"):
            kw = kw.rstrip()
            if len(kw):
                r.add(kw)
    assert len(r) == 672
    return r

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
    print pattern
    regexobj = re.compile(pattern)
    start = 0
    while True:
        match = regexobj.search(buffer, start)
        if not match: break
        #hits += len(match.groups())
        print match.group(0) + ":",
        for k in keywords:
            #where = match.group(0).find(k)
            where = k.find(match.group(0))
            if where == 0:
                print k,
                hits += 1
        print
        start = match.start() + 1
    return hits

if __name__ == "__main__":
    buffer = open("reuters21578/reut2-000.sgm", "rb").read()
    start = time.time()
    print re_count(get_keywords(), buffer)
    print time.time() - start
