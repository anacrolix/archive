#!/usr/bin/env python

from __future__ import division
from operator import add
from itertools import product
from pdb import set_trace

def DR(repeat=2):
	return product(range(1, 7), repeat=repeat)

def sum2d6_first():
	domain = tuple(sorted(set(sum(a) for a in DR())))
	print domain
	for target in domain:
		print target,
		hits = nrrolls = cumeffct = 0
		for roll in DR():
			nrrolls += 1
			if sum(roll) <= target:
				hits += 1
				cumeffct += roll[0]
		print 100 * (hits / nrrolls),
		print cumeffct / nrrolls

def blah():
	class HitStat(object):
		def __init__(self):
			self.freq = 0
			self.dmgsum = 0
		def __repr__(self):
			return "{0}(freq={1}, avdmg={2})".format(
					self.__class__.__name__,
					self.freq,
					self.dmgsum / self.freq)
	hitstats = {}
	rollcnt = 0
	for a, b in DR():
		rollcnt += 1
		hit = a
		dmg = b
		if a == 6 or b == 6:
			hit = dmg = sum([a, b]) - 1
		hitstat = hitstats.setdefault(hit, HitStat())
		hitstat.freq += 1
		hitstat.dmgsum += dmg
	#print rollcnt
	lstchnce = 1
	lstavdmg = 1
	lstzavdg = 1
	for hdr in ["hitrl", "chance", "chcchg", "avdmg", "avdchg", "zavdmg", "zavdch"]:
		print "{0:6s}".format(hdr),
	else:
		print
	for roll, stat in sorted(hitstats.iteritems()):
		hitfreq = sum(map(lambda k: hitstats[k].freq, (filter(lambda k: k >= roll, hitstats))))
		chance = hitfreq / rollcnt
		avdmg = sum(map(lambda k: hitstats[k].dmgsum, (filter(lambda k: k >= roll, hitstats)))) / hitfreq
		zavdmg = avdmg * chance
		for val in [roll, chance, lstchnce / chance, avdmg, avdmg / lstavdmg, avdmg * chance, lstzavdg / zavdmg]:
			print "{0:6.3f}".format(val),
		else:
			print
		lstchnce = chance
		lstavdmg = avdmg
		lstzavdg = zavdmg

def f1d6expand_updown():
	hitfreq = {}
	rollcnt = 0
	for dieone, dietwo, diethree, diefour in DR(4):
		rollcnt += 1
		if diethree in [6]:
			uproll = dieone + diethree
		else:
			uproll = dieone
		if diefour in [6]:
			downroll = dietwo + diefour
		else:
			downroll = dietwo
		hitroll = uproll - downroll
		hitfreq.setdefault(hitroll, 0)
		hitfreq[hitroll] += 1
	for hitroll in sorted(hitfreq):
		print hitroll, sum(map(lambda k: hitfreq[k], filter(lambda k: k >= hitroll, hitfreq))) / rollcnt
	#print hitfreq

def extend_on_sixes(diceseq):
	retval = 0
	for die in diceseq:
		retval += die
		if die != 6:
			break
	return retval

def f2d6up_6extend():
	hitfreq = {}
	rollcnt = 0
	for leftdice in DR(4):
		for rightdice in DR(4):
			rollcnt += 1
			hitroll = extend_on_sixes(leftdice)
			hitroll += extend_on_sixes(rightdice)
			hitfreq.setdefault(hitroll, 0)
			hitfreq[hitroll] += 1
	for hitroll in sorted(hitfreq):
		print hitroll, sum(map(lambda k: hitfreq[k], filter(lambda k: k >= hitroll, hitfreq))) / rollcnt
	#print hitfreq

def d6_expand(depth):
	for dice in DR(depth):
		sum = 0
		for die in dice:
			sum += die
			if die != 6:
				break
		yield sum

def score_to_dice():
	from itertools import repeat
	for score in xrange(1, 16):
		rollcnt = 0
		rollsum = 0
		numdice, bonus = divmod(score, 4)
		while numdice < 1:
			numdice += 1
			bonus -= 4
		print numdice, bonus
		from itertools import repeat
		for d6erolls in product(d6_expand(3), repeat=numdice):
			rollcnt += 1
			thisroll = sum(d6erolls) + bonus
			if thisroll < 1: thisroll = 1
			rollsum += thisroll
		print score, rollsum / rollcnt

if __name__ == "__main__":
	f1d6expand_updown()
