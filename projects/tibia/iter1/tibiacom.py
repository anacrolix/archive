import http.client
import urllib
import re
import htmlutil
import time

TIBIACOM_HOST = "www.tibia.com"

def __decode_html(string):
	return htmlutil.decode_htmlentities(string).replace("\xa0", " ")

def http_connect(host):
	return http.client.HTTPConnection(host)

def http_read(conn, method, url):
	conn.request(method, url)
	resp = conn.getresponse()
	data = resp.read()
	print("read", len(data), "bytes from", url)
	return data

def parse_list(data, keys, reobj):
	return [ dict(zip(keys, match.groups())) for match in reobj.finditer(data) ]

def who_is_online(world):
	conn = http_connect(TIBIACOM_HOST)
	params = urllib.parse.urlencode(
			{"subtopic": "whoisonline", "world": world})
	body = http_read(conn, "GET", "/community/?" + params)
	update_time = time.time()
	print("time =", update_time)
	players = parse_list(str(body), ("name", "level", "vocation"), re.compile("""<TR BGCOLOR=#[A-F0-9]+><TD WIDTH=\d+%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">([^<]+)</A></TD><TD WIDTH=\d+%>(\d+)</TD><TD WIDTH=\d+%>([^<]+)</TD></TR>"""))
	for p in players:
		p["name"] = __decode_playername(p["name"])
	return players, update_time

def character_info(name, conn=None):
	if conn is None: conn = http_connect(TIBIACOM_HOST)
	params = urllib.parse.urlencode(
			{"subtopic": "characters", "name": name})
	print(params)
	body = http_read(conn, r"GET", r"/community/?" + params)
	raw_deaths = parse_list(str(body), ["time", "level", "final_isplayer", "final_name", "assist_isplayer", "assist_name"], re.compile("""<TR BGCOLOR=#[A-Za-z0-9]+><TD WIDTH=25%>([^<>]+)</TD><TD>(?:Killed|Died)? at Level (\d+) by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">)?([^<>]+)(?:</A>)?</TD></TR>(?:\s*<TR BGCOLOR=#[0-9A-Za-z]+><TD WIDTH=25%></TD><TD>and by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">)?([^<>]+)(?:</A>)?</TD></TR>)?"""))
	deaths = []
	for rd in raw_deaths:
		print("raw death:", rd)
		d = {}
		d["time"] = __decode_html(rd["time"])
		d["level"] = int(rd["level"])
		d["killers"] = []
		k = {}
		k["name"] = __decode_html(rd["final_name"])
		k["monster"] = False if rd["final_isplayer"] else True
		k["assist"] = False
		d["killers"].append(k)
		k = {}
		if rd["assist_name"] is not None:
			assert rd["assist_isplayer"]
			k["name"] = __decode_html(rd["assist_name"])
			k["monster"] = False if rd["assist_isplayer"] else True
			k["assist"] = True
			d["killers"].append(k)
		else:
			assert not rd["assist_isplayer"]
		#print(d)
		deaths.append(d)
	return deaths
