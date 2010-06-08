#!/usr/bin/env python

import itertools, math, time

while True:
	slptime = 1 - math.modf(time.time())[0]
	if slptime >= 1:
		slptime = 0
	time.sleep(slptime)
	print int(time.time())
