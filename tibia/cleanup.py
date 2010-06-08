#!/usr/bin/env python

class LootSystemParser(object):
	def __init__(self):
		self.selldest = {}
		self.wareinfo = {}
		self.buyerloc = {}
		datafile = open("loot-system")
		for line in datafile:
			if line.strip() == "[SORTING]":
				self.parse_sorting(datafile)
			elif line.strip() == "[WARES]":
				self.parse_wares(datafile)
			else:
				assert not line
	def parse_sorting(self, lineiter):
		for line in lineiter:
			line = line.rstrip()
			if not line:
				return
			dest, bpcolor = line.split(",")
			print dest, bpcolor
			assert dest not in self.selldest
			self.selldest[dest] = bpcolor
	def repair_field(self, rawfield):
		return " ".join(map(str.capitalize, rawfield.strip().split()))
	def parse_wares(self, lineiter):
		for line in lineiter:
			fields = line.split(",")
			if len(fields) == 2:
				itemname, selldest = fields
				buyernam = selldest
			elif len(fields) == 3:
				itemname, value, selldest = fields
				buyernam = selldest
			else:
				itemname, value, selldest, buyernam = fields
			itemname = self.repair_field(itemname)
			buyernam = self.repair_field(buyernam)
			selldest = self.repair_field(selldest)
			#itemname = itemname.strip().capitalize()
			assert itemname not in self.wareinfo
			self.wareinfo[itemname] = (value, buyernam)
			if buyernam:
				if buyernam in self.buyerloc:
					assert selldest == self.buyerloc[buyernam], itemname
				else:
					self.buyerloc[buyernam] = selldest
			print itemname, value

def main():
	a = LootSystemParser()
	print a.buyerloc
	print a.wareinfo
	print a.selldest

main()
