#!/usr/bin/env python

from chorspool import *
results = []
Horspool_call(Horspool_new("matt"), "where is matt?", results.append)
print results
assert results == [9]
