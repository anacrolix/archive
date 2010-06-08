#!/usr/bin/env python

import os, sys
import pytibia

if len(sys.argv) >= 2:
	prefix = sys.argv[1]
else:
	prefix = "_memdump_"
delfiles = []
for entry in os.listdir("."):
	if entry.startswith(prefix):
		delfiles.append(entry)
if delfiles:
	print "\n\t".join(["The following files will be deleted:"] + delfiles)
	raw_input("Press enter to continue...")
	for filepath in delfiles:
		os.remove(filepath)
client = pytibia.Client()
for address, data in client.iter_memory_regions():
	open("{0}{1:08x}".format(prefix, address), "wb").write(data)
