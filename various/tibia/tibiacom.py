import http.client
import urllib
import re

TIBIACOM_HOST = "www.tibia.com"

def __decode_playername(string):
	return decode_htmlentities(string).replace("\xa0", " ")

def http_connect(host):
	return http.client.HTTPConnection(host)

def http_read(conn, method, url):
	conn.request(method, url)
	resp = conn.getresponse()
	data = resp.read()
	print("read", len(data), "bytes from", url)
	return data

def parse_list(data, keys, reobj):
	pass

def who_is_online(world):
	conn = http_connect(TIBIACOM_HOST)
	params = urllib.parse.urlencode(
			{"subtopic": "whoisonline", "world": world})
	body = http_read(conn, "GET", "/community/?" + params)
	data = parse_list(body, ("name", "level", "vocation"), """<TR BGCOLOR=#[A-F0-9]+><TD WIDTH=\d+%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">([^<]+)</A></TD><TD WIDTH=\d+%>(\d+)</TD><TD WIDTH=\d+%>([^<]+)</TD></TR>""")
	return data
