#!/usr/bin/env python

import struct, sys
import pytibia

address = int(sys.argv[1], 0)
pid = pytibia.find_client_pid()
for mapline in pytibia.iter_proc_maps(pid):
	if address >= mapline.start and address < mapline.end:
		print mapline
		break
print "Offset:", hex(address - mapline.start)
buffer = pytibia.read_process_memory(pid, address, 4)
value = struct.unpack("I", buffer)[0]
print "Current value:", hex(value), value, repr(buffer)
