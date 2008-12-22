from html.entities import name2codepoint as n2cp
import re

def __substitute_entity(match):
	ent = match.group(2)
	if match.group(1) == "#":
		return chr(int(ent))
	else:
		cp = n2cp.get(ent)

	if cp:
		return unichr(cp)
	else:
		return match.group()

def decode_htmlentities(string):
	entity_re = re.compile("&(#?)(\d{1,5}|\w{1,8});")
	return entity_re.subn(__substitute_entity, string)[0]
