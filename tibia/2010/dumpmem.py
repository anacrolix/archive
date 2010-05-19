#!/usr/bin/env python

import os, sys
import pytibia

if len(sys.argv) >= 2:
	prefix = sys.argv[1]
else:
	prefix = "_memdump_"
#for entry in os.listdir("."):
	#if entry.startswith(prefix):
		#print entry
client = pytibia.Client()
for address, data in client.iter_memory_regions():
	open("{0}{1:08x}".format(prefix, address), "wb").write(data)
