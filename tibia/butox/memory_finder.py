#!/usr/bin/env python

import pdb, struct
import pytibia

oldmemrs = {}
oldaddrs = None

valstrct = raw_input("Enter value struct type (I): ")
valstrct = struct.Struct(valstrct or "I")
valalign = min(4, valstrct.size)

def show_candidates():
	for candaddr in sorted(oldaddrs):
		for memraddr, memrdata in oldmemrs.iteritems():
			if candaddr >= memraddr and candaddr < memraddr + len(memrdata):
				candidx = candaddr - memraddr
				candval = valstrct.unpack(memrdata[candidx:candidx+valstrct.size])[0]
				print "{0:08x}: {1:x},".format(candaddr, candval),
	print

while oldaddrs is None or len(oldaddrs):
	print "Remaining addresses:",
	if oldaddrs is None:
		print "<Entire memory space>"
	elif len(oldaddrs) > 40:
		print "<{0} possibilities>".format(len(oldaddrs))
	else:
		show_candidates()
	while True:
		newexpr = raw_input("Enter new expression: ")
		if not newexpr:
			print "Taking memory snapshot"
		elif newexpr == ".show":
			show_candidates()
			continue
		else:
			try:
				newexpr = compile(newexpr, "<newexpr>", 'eval')
			except SyntaxError as e:
				print e
				continue
		break
	newaddrs = set()
	newmemrs = {}
	for address, data in tuple(pytibia.Client().iter_memory_regions()):
		if newexpr:
			if oldaddrs is None:
				idxiter = xrange(0, len(data), valalign)
			else:
				idxiter = set()
				for addr in oldaddrs.copy():
					if addr >= address and addr < address + len(data):
						oldaddrs.remove(addr)
						idxiter.add(addr - address)
			for index in idxiter:
				if address not in oldmemrs:
					old = None
				else:
					old = valstrct.unpack(oldmemrs[address][index:index+valstrct.size])[0]
				new = valstrct.unpack(data[index:index+valstrct.size])[0]
				#pdb.set_trace()
				#print old, new
				if eval(newexpr, {}, {"old": old, "new": new}):
					newaddrs.add(address + index)
		newmemrs[address] = data
	#assert oldaddrs is None or len(oldaddrs) == 0, len(oldaddrs)
	if newexpr:
		if oldaddrs is not None:
			if len(oldaddrs):
				print "Dropping lost addresses:",
				for addr in oldaddrs:
					assert addr not in newaddrs
					print "{0:08x}".format(addr),
				print
		oldaddrs = newaddrs
	oldmemrs = newmemrs
