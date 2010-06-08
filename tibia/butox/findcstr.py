#!/usr/bin/env python

import sys
import pytibia

target = sys.argv[1]
context = 10
print "Finding", repr(target)
client = pytibia.Client()
for address, buffer in client.iter_memory_regions():
	pos = -1
	while True:
		pos = buffer.find(target, pos + 1)
		if pos == -1:
			break
		print hex(address + pos), repr(buffer[pos-context:pos+len(target)+context])
