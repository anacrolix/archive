#!/usr/bin/env python

def fibonacci():
	last = 0
	current = 1
	while True:
		last, current = current, last + current
		yield current

sum = 0
for n in fibonacci():
	if n <= 4000000:
		if not n & 1:
			print n
			sum += n
	else:
		break
print sum
