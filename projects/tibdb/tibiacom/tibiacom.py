#!/usr/bin/env python

from __future__ import print_function
import collections, pdb, pprint, re, sys, time

try:
    from html.parser import HTMLParser, HTMLParseError
    from http.client import IncompleteRead
    from urllib.request import urlopen
    from html.entities import name2codepoint
    from urllib.parse import urlencode
except ImportError:
    from httplib import IncompleteRead
    from HTMLParser import HTMLParser, HTMLParseError
    from urllib2 import urlopen, Request as UrlRequest
    from urllib import urlencode
    from htmlentitydefs import name2codepoint

import url

#_TIBIA_TIME_STRLEN = len("Mon DD YYYY, HH:MM:SS TZ")

def tibia_time_to_unix(s):
    a = s.split()
    b = time.strptime(" ".join(a[:-1]) + " UTC", "%b %d %Y, %H:%M:%S %Z")
    c = int(time.mktime(b))
    c -= time.timezone
    c -= {"CET": 3600, "CEST": 2 * 3600}[a[-1]]
    return c

def dilute_tibia_html_entities(html):
    return html.replace("\xa0", " ")

def unescape_tibia_html(string):
    """Replace HTML entities in the string, and convert any Tibia-specific codepoints"""
    n2cp = name2codepoint
    import re

    def substitute_entity(match):
        ent = match.group(2)
        if match.group(1) == "#":
            # numeric substitution
            return chr(int(ent))
        else:
            # get the codepoint from the name
            cp = n2cp.get(ent)

        if cp:
            #if a codepoint was found, return it's string value
            return chr(cp)
        else:
            # codepoint wasn't found, return the match untouched
            return match.group()

    def decode_entities(string):
        # catch any &(#)(12345); or &()(abcdefgh);
        entity_re = re.compile(r"&(#?)(\d{1,5}|\w{1,8});")
        # substitute all matches in the string with the result of the function call
        return entity_re.subn(substitute_entity, string)[0]

    # replace nbsp, there may be others too..
    return dilute_tibia_html_entities(decode_entities(string))

def pp_death(death):
    b = death
    print(b.time + ":", end=" ")
    print("Died at Level %d to %s" % (b.level, ", ".join(map(lambda x: x.name, b.killers))))

def pretty_print_char_info(info):
    # force name to be printed first, and deaths treated specially later
    simple = list(info.keys())
    for a in ("deaths", "name"): simple.remove(a)
    for k in ["name"] + simple:
        print(k + ":", info[k], end=" ")
        if k in ["created", "last login"] and info[k] is not None:
            print("(" + str(int(time.time()) - tibia_time_to_unix(info[k])) + "s ago)")
        elif k is "timestamp":
            print("(%s CET)" % time.asctime(time.gmtime(info[k] + 3600)))
        else:
            print()
    a = info["deaths"]
    if a != None:
        for b in a:
            pp_death(b)

def http_get(path=None, params=None, url=None):
    """Perform a compressed GET request on the Tibia webserver. Return the decoded response data."""
    if not url:
        url = "http://www.tibia.com" + path + "?" + urlencode(params)
    request = UrlRequest(
            url,
            headers={"Accept-Encoding": "deflate;q=1.0, zlib;q=0.9, gzip;q=0.8, compress;q=0.7, *;q=0"},)
    response = urlopen(request)
    assert response.code == 200

    # decompress the response data
    respdata = response.read()
    assert len(respdata) == int(response.info()["Content-Length"])
    contentEncoding = response.info()["Content-Encoding"]
    if contentEncoding == "gzip":
        import gzip, io
        respdata = gzip.GzipFile(fileobj=io.BytesIO(respdata)).read()

    # retrieve the encoding, so we can decode the bytes to a string
    contentType = response.info()["Content-Type"]
    charset = re.search("charset=([^;\b]+)", contentType).group(1)

    if str != bytes:
        return respdata.decode(charset)
    else:
        return respdata

Killer = collections.namedtuple("Killer", ("isplayer", "name"))
CharDeath = collections.namedtuple("CharDeath", ("time", "level", "killers"))

STR = r"<tr[^>]*>"
ETR = r"</tr>"
STD = r"<td[^>]*>"
ETD = r"</td>"
TIBTIME = r"([^<]+)"
LEVEL = r".*?at Level (\d+) by "
KILLERS = r"(.*?)"

def parse_deaths(pagehtml):
    matchobj = re.search(r"<table.*?>Character Deaths<.*?</table>", pagehtml, re.IGNORECASE)
    if not matchobj:
        return []
    deathhtml = matchobj.group()
    #print(deathhtml)
    alldeaths = []
    for deathmo in re.finditer(STR + STD + TIBTIME + ETD + STD + LEVEL + KILLERS + ETD + ETR, deathhtml, re.IGNORECASE):
        time = unescape_tibia_html(deathmo.group(1))
        tibia_time_to_unix(time)
        level = int(deathmo.group(2))
        killers = []
        for killermo in re.finditer(r"(?:<a[^>]*>)?([^<]+?)(</a>)?(?: and |, |\.)", deathmo.group(3)):
            assert killermo.re.groups == 2
            killers.append(Killer(isplayer=bool(killermo.group(2)), name=unescape_tibia_html(killermo.group(1))))
        alldeaths.append(CharDeath(time=time, level=level, killers=killers))
    #pprint.pprint(alldeaths)
    return alldeaths

def char_info(charname):

    def _ci_info(html):
        """Read the simple FieldName: Value data fields from character page HTML"""
        FIELDS = (
                # key name, field name, data transform, required field
                ("name", "Name", lambda x: unescape_tibia_html(x), True),
                ("sex", "Sex", None, True),
                ("vocation", "Profession", None, True),
                ("level", "Level", None, True),
                ("world", "World", None, True),
                ("residence", "Residence", None, True),
                (       "guild",
                        "Guild&#160;membership",
                        lambda x: unescape_tibia_html(re.search(r"<A.+?>([^<]+)</A>", x).group(1)),
                        False),
                ("last login", "Last login", lambda x: unescape_tibia_html(x), True),
                ("account status", "Account&#160;Status", None, True),
                ("created", "Created", lambda x: unescape_tibia_html(x), False))
        info = {}
        for a in FIELDS:
            hits = re.findall(
                    "<TR.*?><TD.*?>%s:</TD><TD>([^<]+?)</TD></TR>" % a[1],
                    html)
            if len(hits) == 0:
                assert a[3] != True, "Character page for %r: Required field %r not found" % (charname, a[0])
                info[a[0]] = None
            elif len(hits) == 1:
                info[a[0]] = a[2](hits[0]) if a[2] != None else hits[0]
            else:
                assert False
        return info

    rv = {"timestamp": int(time.time())}
    html = http_get(url=url.char_page(charname))
    try:
        rv.update(_ci_info(html))
    except Exception:
        print("name:", charname)
        raise
    assert "deaths" not in rv
    try:
        rv["deaths"] = parse_deaths(html)
    except:
        print("charname:", charname, file=sys.stderr)
        raise
    return rv

class Character(object):
    _fields = ("name", "vocation", "level", "guild")
    def __init__(self, **kwargs):
        super(self.__class__, self).__init__()
        self.__data = {}
        for k, v in kwargs.items():
            self[k] = v
    def __setitem__(self, key, value):
        assert key in self._fields
        assert key not in self.__data
        self.__data[key] = value
    def __getattr__(self, name):
        if name in self._fields:
            return self.__data.get(name)
        else:
            raise AttributeError()
    def update(self, other):
        vars(self).update(vars(other))
    def is_online(self):
        return self.online
    def set_online(self, online, stamp):
        if not hasattr(self, "online"):
            self.last_status_change = stamp if online else 0
        elif online != self.online:
            self.last_status_change = stamp
        self.online = online
    def last_online(self):
        assert not self.online
        return self.last_status_change
    def last_offline(self):
        assert self.online
        return self.last_status_change

def online_list(world):
    stamp = time.time()
    html = http_get("/community/", {"subtopic": "whoisonline", "world": world})
    # html is processed in this function, these are data transformations
    def vocation_check(vocation):
        assert vocation in ("None", "Knight", "Elite Knight", "Paladin", "Royal Paladin", "Druid", "Elder Druid", "Sorcerer", "Master Sorcerer")
        return vocation
    FIELDS = (
        ("name", lambda x: unescape_tibia_html(x)),
        ("level", lambda x: int(x)),
        ("vocation", vocation_check),)
    players = []
    row_re = re.compile("""<TR BGCOLOR=#[A-F0-9]+><TD WIDTH=\d+%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">([^<]+)</A></TD><TD WIDTH=\d+%>(\d+)</TD><TD WIDTH=\d+%>([^<]+)</TD></TR>""")
    for a in row_re.finditer(html):
        assert len(a.groups()) == len(FIELDS)
        # generate a dict from a list of pairs, with keys and values processed through FIELDS
        # FIELDS is iterated by index because of 1-based MatchObject.group()
        players.append(Character(**dict(
                ((f[0], f[1](a.group(i + 1))) for i, f in enumerate(FIELDS)))))
    assert int(re.search(r"Currently (\d+) players are online\.", html).group(1)) == len(players)
    return stamp, players

def guild_list(world):
    html = http_get(url.world_guilds(world))
    groups = re.findall(r'<INPUT TYPE=hidden NAME=GuildName VALUE="([^"]+)', html)
    retval = set()
    for guild in [set([x]) for x in groups]:
        assert len(guild) == 1
        assert retval.isdisjoint(guild)
        retval.update(guild)
    return retval

def guild_info(guild):
    html = http_get(url.guild_members(guild))
    members = set()
    matches = re.findall(r'<TD><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">([^<]+)</A>[^<>]*</TD>', html)
    for m in matches:
        assert m not in members
        members.add(unescape_tibia_html(m))
    return members

def pretty_print_online_list(ol, stamp):
    for a in ol:
        print("%-32s%5s %s" % (a.name, a.level, a.vocation))
    print(len(ol), "players online as of", time.ctime(stamp))

def usage():
    print("""usage: $0 <subcommand> [args]

Available subcommands:
   charinfo""")

def main():
    if sys.argv[1] == "character":
        pretty_print_char_info(char_info(sys.argv[2]))
    elif sys.argv[1] == "whoisonline":
        pretty_print_online_list(*reversed(online_list(sys.argv[2])))
    else:
        usage()
        sys.exit(1)

if __name__ == '__main__':
    main()
