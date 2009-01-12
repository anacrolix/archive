def tibia_time_to_unix(s):
	import time
	a = s.split()
	b = time.strptime(" ".join(a[:-1]) + " UTC", "%b %d %Y, %H:%M:%S %Z")
	c = time.mktime(b)
	c -= {"CET": 3600}[a[-1]]
	return c

def decode_tibia_html(string):
	from htmlentitydefs import name2codepoint as n2cp
	import re

	def substitute_entity(match):
		ent = match.group(2)
		if match.group(1) == "#":
			return chr(int(ent))
		else:
			cp = n2cp.get(ent)

		if cp:
			return unichr(cp)
		else:
			return match.group()

	def decode_entity(string):
		entity_re = re.compile("&(#?)(\d{1,5}|\w{1,8});")
		return entity_re.subn(substitute_entity, string)[0]

	# replace nbsp, there may be others too..
	return decode_entity(string).replace("\xa0", " ")

def pretty_print_char_info(info):
	simple = info.keys()
	simple.remove("deaths")
	for k in simple:
		print k + ":", info[k]
	a = info["deaths"]
	if a != None:
		for b in a:
			print b[0] + ":",
			print "killed" if b[2][0] else "died", "at Level", b[1],
			print "by", b[2][1]
			if b[3] is not None:
				print "\tand by", b[3][1]
