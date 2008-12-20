import http.client
import urllib
import re

TIBIACOM_HOST = "www.tibia.com"

from html.entities import name2codepoint as n2cp
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

def decode_htmlentities(string):
	entity_re = re.compile("&(#?)(\d{1,5}|\w{1,8});")
	return entity_re.subn(substitute_entity, string)[0]

def decode_playername(string):
	return decode_htmlentities(string).replace("\xa0", " ")

def get_connection():
	return http.client.HTTPConnection(TIBIACOM_HOST)

def http_request(conn, method, url):
	conn.request(method, url)
	resp = conn.getresponse()
	data = resp.read()
	print("read", len(data), "bytes from", url)
	return data

class Parsable:
	def __init__(self, pattern, findall=False, keys=None):
		self.regexobj = re.compile(pattern)
		self.findall = findall
		self.keys = keys
		self.expire()

	def expire(self):
		self.expired = True

	def retrieve(self, data):
		if self.expired:
			if self.findall:
				matches = self.regexobj.findall(str(data))
			else:
				matches = self.regexobj.search(str(data)).groups()
			if self.keys is None:
				self.values = matches
			else:
				self.values = list(map(lambda r: dict(zip(self.keys, r)), matches))
			self.expired = False
		return self.values

class PageParser:
	def __init__(self, url, parsables):
		self.url = url
		self.parsables = parsables
		self.data = None

	def update(self):
		conn = get_connection()
		self.data = http_request(conn, "GET", self.url)
		conn.close()
		for parser in self.parsables.values():
			parser.expire()

	def retrieve(self, name):
		if self.data is None:
			self.update()
		return self.parsables[name].retrieve(self.data)

class ServerStatus:
	def __init__(self, world):
		self.world = world
		self.parser = PageParser("/community/?" + urllib.parse.urlencode({"subtopic": "whoisonline", "world": self.world}), {"players_online": Parsable(r"Currently (\d+) players are online\."), "who_online_list": Parsable("""<TR BGCOLOR=#[A-F0-9]+><TD WIDTH=\d+%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">([^<]+)</A></TD><TD WIDTH=\d+%>(\d+)</TD><TD WIDTH=\d+%>([^<]+)</TD></TR>""", True, ("name", "level", "vocation"))})

	def update(self):
		self.parser.update()

	def player_count(self):
		m = int(self.parser.retrieve("players_online")[0])
		n = len(self.parser.retrieve("who_online_list"))
		assert m == n
		return m

	def online_list(self):
		r = self.parser.retrieve("who_online_list")
		for player in r:
			player["name"] = decode_playername(player["name"])
			player["level"] = int(player["level"])
		return r
