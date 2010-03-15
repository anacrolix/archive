#!/usr/bin/env python

import calendar, collections, htmlentitydefs, httplib, logging, os.path, pdb, pprint, re, string, sys, threading, time, urllib, urllib2, urlparse

#_TIBIA_TIME_STRLEN = len("Mon DD YYYY, HH:MM:SS TZ")

Killer = collections.namedtuple("Killer", ("isplayer", "name"))
CharDeath = collections.namedtuple("CharDeath", ("time", "level", "killers"))

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
    def __ne__(self, other):
        return not self == other
    def __eq__(self, other):
        for a in self._fields:
            if getattr(self, a) != getattr(other, a):
                return False
        else:
            return True
    def __repr__(self):
        return "{0}({1})".format(self.__class__.__name__, ", ".join(("{0}={1!r}".format(f, getattr(self, f)) for f in self._fields)))

def tibia_time_to_unix(s):
    a = s.split()
    #b = time.strptime(" ".join(a[:-1]) + " UTC", "%b %d %Y, %H:%M:%S %Z")
    b = time.strptime(" ".join(a[:-1]), "%b %d %Y, %H:%M:%S")
    c = calendar.timegm(b)
    #c = int(time.mktime(b))
    #c -= time.timezone
    HOUR = 3600
    c -= HOUR * {"CET": 1, "CEST": 2}[a[-1]]
    return c

def next_whoisonline_update(secs=None):
    """Returns the unix epoch of the next reasonable time to update from tibia.com whoisonline pages"""
    a = list(time.gmtime(secs))
    min = (((((a[4] - 1) // 5) + 1) * 5) + 1)
    return calendar.timegm(a[0:4] + [min, 0] + a[6:9])

def make_tibia_url(path, query):
    return urlparse.urlunsplit((
            "http",
            "www.tibia.com",
            path,
            urllib.urlencode(query),
            None),)

def char_page_url(name):
    return make_tibia_url("/community/", {"subtopic": "characters", "name": name})

def world_guilds_url(world):
    return make_tibia_url("/community/", {"subtopic": "guilds", "world": world})

def guild_members_url(guild):
    return make_tibia_url("/community/", {"subtopic": "guilds", "page": "view", "GuildName": guild})

def world_online_url(world):
    assert isinstance(world, str)
    return make_tibia_url("/community/", {"subtopic": "whoisonline", "world": world})

def http_get(url):
    """Perform a compressed GET request on the Tibia webserver. Return the decoded response data and other info."""

    # prefer deflate, zlib, gzip as they add ascending levels of headers in that order
    # compress is not as strong compression, prefer it next
    # avoid identity and unhandled encodings at all cost
    request = urllib2.Request(
            url,
            headers={"Accept-Encoding": "deflate;q=1.0, zlib;q=0.9, gzip;q=0.8, compress;q=0.7, *;q=0"},)
    retries = 0
    while True:
        try:
            response = urllib2.urlopen(request)
        except urllib2.HTTPError as e:
            if e.code != 403:
                raise
            else:
                retries += 1
                print "fail:", time.time(), threading.current_thread().name
                time.sleep(retries)
        else:
            break
    del retries

    respdata = response.read()
    response.close()
    assert response.code == 200, (response.code, respdata)
    # decompress the response data
    assert len(respdata) == int(response.info()["Content-Length"])
    contentEncoding = response.info()["Content-Encoding"]
    if contentEncoding == "gzip":
        import gzip, io
        respdata = gzip.GzipFile(fileobj=io.BytesIO(respdata)).read()

    # retrieve the encoding, so we can decode the bytes to a string
    contentType = response.info()["Content-Type"]
    charset = re.search("charset=([^;\b]+)", contentType).group(1)

    if str != bytes:
        respdata = respdata.decode(charset)
    return respdata, response.info()

#tibiacomConnection = httplib.HTTPConnection("www.tibia.com")
#tibiacomConnLock = threading.Lock()

#def http_get(url):
    #"""Perform a compressed GET request on the Tibia webserver. Return the decoded response data and other info."""

    ## prefer deflate, zlib, gzip as they add ascending levels of headers in that order
    ## compress is not as strong compression, prefer it next, avoid identity and unhandled encodings at all cost
    #with tibiacomConnLock:
        #tibiacomConnection.request("GET", url, headers={
                #"Accept-Encoding": "deflate;q=1.0, zlib;q=0.9, gzip;q=0.8, compress;q=0.7, *;q=0",})
        #response = tibiacomConnection.getresponse()
        #assert response.status == 200
        ##if response.status != 200:
        ##    logging.error("%d: %s", response.status, response.reason)
        ##else:
        ##    break
            ##print response.status, response.reason
            ##print response.getheaders()
            ###assert response.status == 200

        ## decompress the response data
        #respdata = response.read()
    ##response.close()
    #contentLength = response.msg["Content-Length"]
    #assert len(respdata) == int(response.msg["Content-Length"])
    #contentEncoding = response.msg.getheader("Content-Encoding")
    #if contentEncoding == "gzip":
        #import gzip, io
        #respdata = gzip.GzipFile(fileobj=io.BytesIO(respdata)).read()

    ## retrieve the encoding, so we can decode the bytes to a string
    #contentType = response.msg["Content-Type"]
    #charset = re.search("charset=([^;\b]+)", contentType).group(1)

    #if str != bytes:
        #respdata = respdata.decode(charset)
    #return respdata, response.msg


STR = r"<tr[^>]*>"
ETR = r"</tr>"
STD = r"<td[^>]*>"
ETD = r"</td>"
TIBTIME = r"([^<]+)"
LEVEL = r".*?at Level (\d+) by "
KILLERS = r"(.*?)"

def tibia_worlds_url():
    return make_tibia_url("/community/", {"subtopic": "whoisonline"})

def parse_tibia_worlds(html):
    worldNames = set()
    for mo in re.finditer(
            r'<A HREF="http://www.tibia.com/community/\?subtopic=whoisonline&world=([^"]+)">', html):
        worldNames.add(mo.group(1))
    return worldNames

def tibia_worlds():
    html = http_get(tibia_worlds_url())[0]
    return parse_tibia_worlds(html)

def dilute_tibia_html_entities(html):
    return html.replace("\xa0", " ")

def unescape_tibia_html(string):
    """Replace HTML entities in the string, and convert any Tibia-specific codepoints"""
    n2cp = htmlentitydefs.name2codepoint

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

def _parse_char_page_deaths(html):
    matchobj = re.search(r"<table.*?>Character Deaths<.*?</table>", html, re.IGNORECASE)
    if not matchobj:
        return []
    html = matchobj.group()
    #print(deathhtml)
    alldeaths = []
    for deathmo in re.finditer(STR + STD + TIBTIME + ETD + STD + LEVEL + KILLERS + ETD + ETR, html, re.IGNORECASE):
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

def parse_char_page(html, name):
    info = {}

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
            ("last_login", "Last login", lambda x: unescape_tibia_html(x), True),
            ("account_status", "Account&#160;Status", None, True),
            ("created", "Created", lambda x: unescape_tibia_html(x), False))
    for key, field, transform, required in FIELDS:
        hits = re.findall(
                "<TR.*?><TD.*?>{0}:</TD><TD>(.+?)</TD></TR>".format(field),
                html)
        if len(hits) == 0:
            assert not required, "Character page for %r: Required field %s not found" % (name, field)
            info[key] = None
        elif len(hits) == 1:
            info[key] = transform(hits[0]) if transform != None else hits[0]
        else:
            assert False, "Too many hits for field"

    # special name field handling
    a = info["name"].split(",", 1)
    info["name"] = a[0]
    if len(a) > 1:
        info["deletion"] = a[1].strip()
    assert info["name"] == name, (info["name"], name)

    info["deaths"] = _parse_char_page_deaths(html)

    return info

def get_char_page(name):
    return parse_char_page(http_get(char_page_url(name))[0], name)

def get_world_online(world):
    return parse_world_online(http_get(world_online_url(world))[0])

def parse_world_online(html):
    assert html
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

    # check the page player count matches the number of players we found
    pagePlayerCount = re.search(r"Currently (\d+) players are online\.", html)
    if pagePlayerCount is not None:
        pagePlayerCount = int(pagePlayerCount.group(1))
    else:
        pagePlayerCount = 0
    assert len(players) == pagePlayerCount
    return players

def parse_world_guilds(html, world):
    groups = re.findall(r'<INPUT TYPE=hidden NAME=GuildName VALUE="([^"]+)', html)
    retval = set()
    for guild in [set([x]) for x in groups]:
        assert len(guild) == 1
        assert retval.isdisjoint(guild)
        retval.update(guild)
    return retval

def parse_guild_members(html, guild):
    members = set()
    matches = re.findall(r'<TD><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">([^<]+)</A>[^<>]*</TD>', html)
    for m in matches:
        assert m not in members
        members.add(unescape_tibia_html(m))
    return members

def main():
    pprint.pprint(globals()[sys.argv[1]](*sys.argv[2:]))

if __name__ == "__main__":
    main()
