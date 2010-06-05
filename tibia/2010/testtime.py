#!/usr/bin/env python

import subprocess, time

def monotonic_time():
	child = subprocess.Popen(["./monoclk"], stdout=subprocess.PIPE)
	retval = float(child.communicate()[0])
	assert child.returncode == 0
	return retval

oldtime = time.time()
oldmttim = monotonic_time()
while True:
	newmttim = monotonic_time()
	if newmttim < oldmttim:
		print "Monotonic:", oldmttim, newmttim
	oldmttim = newmttim
	newtime = time.time()
	if newtime < oldtime:
		print "Unix time:", oldtime, newtime
	oldtime = newtime
