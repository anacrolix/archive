#!/usr/bin/env python

import pytibia

client = pytibia.Client()

entcount = 0
for entity in client.iter_entities():
	print entity
	entcount += 1
print "Total entities in memory:", entcount
