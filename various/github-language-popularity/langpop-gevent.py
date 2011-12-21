#!/usr/bin/env python2.7

from __future__ import print_function

import gevent.monkey; gevent.monkey.patch_all()
import logging, urllib2, urlparse, re, itertools
from urllib2 import urlopen
from urllib import unquote, quote
from gevent import Greenlet
from gevent.pool import Pool
from Queue import Queue
from functools import partial

def language_popularity(lang):
    qlang = quote(lang)
    try:
        sub = urlopen("http://github.com/languages/" + qlang).read()
    except:
        logging.exception('Error fetching %r', lang)
        return
    match = re.search(b'is the #(\\d+)', sub)
    if match:
        rank = int(match.group(1))
    else:
        rank = 1
    return rank, lang

def languages():
    for match in re.finditer(b'/languages/([^/]+?)"', urlopen('http://github.com/languages').read()):
        yield unquote(match.group(1).decode())

def got_langpop(q, g):
    q.put(g.value)

def main():
    q = Queue()
    nlangs = 0
    for lang in languages():
        g = Greenlet(language_popularity, lang)
        g.link(partial(got_langpop, q))
        g.start()
        nlangs += 1
    ranks = {}
    for rank in itertools.count(1):
        while rank not in ranks and nlangs > 0:
            result = q.get()
            nlangs -= 1
            new_rank, lang = result
            ranks[new_rank] = lang
        if rank not in ranks:
            break
        print(rank, ranks[rank])
    for rank1 in sorted(r for r in ranks if r >= rank):
        print(rank1, ranks[rank1])

if __name__ == '__main__':
    main()
