#!/usr/bin/env python

#import itertools, math, time

#while True:
	#slptime = 1 - math.modf(time.time())[0]
	#if slptime >= 1:
		#slptime = 0
	#time.sleep(slptime)
	#print int(time.time())

def handler(signum, frame):
	from time import ctime
	print ctime()
	assert 0 == alarm(1)

from signal import alarm, pause, signal, SIGALRM
signal(SIGALRM, handler)
assert 0 == alarm(1)
while True:
	pause()
