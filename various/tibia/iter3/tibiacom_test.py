#!/usr/bin/env python

def assert_equal(expected, actual, description=None):
	if expected != actual:
		print "FAILED:",
		if description != None: print description
		print "\tExpected:", expected
		print "\tActual:  ", actual
		print

from tibiacom import *
print

# test tibia_time_to_unix()
A = [("Jan 01 1970, 10:00:00 CET", 9 * 3600),
	("Jan 01 1970, 01:00:00 CET", 0),
	(time.strftime("%b %d %Y, %H:%M:%S CET", time.gmtime(int(time.time()+3600))), int(time.time()))]
assert_equal(0, time.mktime(time.localtime(0)))
for a in A:
	assert_equal(a[1], tibia_time_to_unix(a[0]), repr(a))

# test char_info()
skeletor = char_info("Skeletor the Vicious")
assert_equal(1064301567, tibia_time_to_unix(skeletor["created"]))
pretty_print_char_info(char_info("Eruanno"))
print

# test online_list()
stamp, online = online_list("Dolera")
pretty_print_online_list(online, stamp)
print

pretty_print_online_list(sorted(online, reverse=True, key=lambda x: int(x["level"]))[:10], stamp)

for a in sorted(online, reverse=True, key=lambda x: int(x["level"])):
	b = char_info(a["name"])
	for c in b["deaths"]:
		if tibia_time_to_unix(c[0]) >= stamp - 900:
			pretty_print_char_info(b)
			break
	else:
		print a["name"]
