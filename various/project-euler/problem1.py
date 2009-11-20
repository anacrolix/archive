#!/usr/bin/env python

sum = 0
for n in xrange(1, 1000):
	if not n % 3 or not n % 5:
		print n
		sum += n
print sum
