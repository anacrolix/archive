import collections
from html.parser import HTMLParser, HTMLParseError
import pdb
import re
import urllib.request, urllib.parse, urllib.error
import time

TIBIA_TIME_STRLEN = len("Mon DD YYYY, HH:MM:SS TZ")

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
    from html.entities import name2codepoint as n2cp
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
    print(b[0] + ":",)
    print("killed" if b[2][0] else "died", "at Level", b[1],)
    print("by", b[2][1])
    if b[3] is not None:
            print("\tand by", b[3][1])

def pretty_print_char_info(info):
    simple = list(info.keys())
    for a in ["deaths", "name"]: simple.remove(a)
    for k in ["name"] + simple:
        print(k + ":", info[k],)
        if k in ["created", "last login"] and info[k] is not None:
            print("(" + str(int(time.time()) - tibia_time_to_unix(info[k])) + "s ago)")
        elif k is "timestamp":
            print("(" + time.asctime(time.gmtime(info[k] + 3600)), "CET)")
        else:
            print()
    a = info["deaths"]
    if a != None:
        for b in a:
            pp_death(b)

def http_get(url, params):
    """Perform a GET request on the Tibia webserver, with the given parameters. Return the decoded response data."""
    response = urllib.request.urlopen(
            "http://www.tibia.com" + url + "?" + urllib.parse.urlencode(params))
    # retrieve the encoding, so we can decode the bytes to a string
    content_type = response.getheader("Content-Type")
    charset = re.search("charset=([^;\b]+)", content_type).group(1)
    # read the response data and decode appropriately
    return response.read().decode(charset)

def __ci_info(html):
    FIELDS = (
        ("name", "Name", lambda x: unescape_tibia_html(x)),
        ("sex", "Sex", None),
        ("vocation", "Profession", None),
        ("level", "Level", None),
        ("world", "World", None),
        ("residence", "Residence", None),
        ("guild", "Guild&#160;membership", lambda x: unescape_tibia_html(re.search(r"<A.+?>([^<]+)</A>", x).group(1))),
        ("last login", "Last login", lambda x: unescape_tibia_html(x)),
        ("account status", "Account&#160;Status", None),
        ("created", "Created", lambda x: unescape_tibia_html(x)))
    info = {}
    for a in FIELDS:
        hits = re.findall(
            "<TR.*?><TD.*?>%s:</TD><TD>([^<]+?)</TD></TR>" % a[1],
            html)
        if len(hits) == 0:
            info[a[0]] = None
        elif len(hits) == 1:
            info[a[0]] = a[2](hits[0]) if a[2] != None else hits[0]
        else:
            assert False
    return info

Killer = collections.namedtuple("Killer", ("player", "name"))
CharDeath = collections.namedtuple("CharDeath", ("time", "level", "killers"))

class _DeathParser(HTMLParser):
    def parse_deaths(self, html):
        self.section = ''
        self.alldeaths = []
        try:
            self.feed(html)
        except HTMLParseError as e:
            print(e)
        assert self.section == 'finished'
        return self.alldeaths
    def handle_data(self, data):
        if self.section == 'deaths':
            self.data += data
        if data == "Character Deaths":
            self.section = 'deaths'
            self.deathrow = 0
    def handle_starttag(self, tag, attrs):
        if self.section == 'deaths':
            if tag == 'tr':
                self.death = []
            elif tag == 'td':
                self.data = ""
    def handle_endtag(self, tag):
        if self.section == 'deaths':
            if tag == 'tr':
                if self.deathrow != 0:
                    assert len(self.death) == 2
                    tibia_time_to_unix(self.death[0])
                    self.alldeaths.append(self.death)
                    del self.death
                self.deathrow += 1
            elif tag == 'td' and self.deathrow != 0:
                self.death.append(self.data)
                del self.data
            elif tag == 'table':
                assert not hasattr(self, "death")
                self.section = 'finished'
    def handle_charref(self, name):
        if self.section == 'deaths':
            self.data += dilute_tibia_html_entities(chr(int(name)))
    #def handle

def parse_deaths(html):
    return _DeathParser().parse_deaths(html)
    #def slayer_tuple(group):
        #assert len(group) == 2
        #if group[0] == None:
            #assert group[1] != None
            #return (False, group[1])
        #else:
            #assert group[1] == None
            #return (True, unescape_tibia_html(group[0]))

    ## navigate to start of deaths table
    #m = re.search("""<TABLE.*?>Character Deaths.*?</TR>""", html)
    #if m == None: return []
    #pos = m.end()

    #CHAR_OR_MONSTER_PATTERN = """(?:<A.*?>([^<]*)</A>|([^<]*))"""
    ## time, level, killer
    #kill1_re = re.compile(
            #"""<TR.*?><TD.*?>([^<]+)</TD><TD>\S+ at Level (\d+) by """
            #+ CHAR_OR_MONSTER_PATTERN
            #+ """</TD></TR>""")
    ## killer
    #kill2_re = re.compile(
            #"""\s*<TR.*?><TD.*?></TD><TD>and by """
            #+ CHAR_OR_MONSTER_PATTERN
            #+ """</TD></TR>""")

    #deaths = []
    #while True:
        #mo = kill1_re.search(html, pos)
        #if mo is None: break
        #time = unescape_tibia_html(mo.group(1))
        #level = mo.group(2)
        #death = [time, level, slayer_tuple(mo.group(3, 4)), None]
        #pos = mo.end()
        #mo2 = kill2_re.match(html, pos)
        #if mo2 is not None:
            #death[3] = slayer_tuple(mo2.group(1, 2))
            #pos = mo2.end()
        #deaths.append(tuple(death))

    #return deaths

def download_character_page_html(charname):
    return http_get("/community/", {"subtopic": "characters", "name": charname})

def char_info(charname):
    rv = {"timestamp": int(time.time())}
    html = download_character_page_html(charname)
    try: rv.update(__ci_info(html))
    except Exception:
        print("name:", charname)
        raise
    assert "deaths" not in rv
    rv["deaths"] = parse_deaths(html)
    return rv

class Character():
    def __init__(self, **stats):
        for k, v in stats.items():
            setattr(self, k, v)
    #def __cmp__(self, other):
        #return cmp(self.name, other.name)
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
    FIELDS = (
        ("name", lambda x: unescape_tibia_html(x)),
        ("level", lambda x: int(x)),
        ("vocation", lambda x: {
                "None": "N",
                "Knight": "K",
                "Elite Knight": "EK",
                "Paladin": "P",
                "Royal Paladin": "RP",
                "Druid": "D",
                "Elder Druid": "ED",
                "Sorcerer": "S",
                "Master Sorcerer": "MS"}
            [x]))
    players = []
    row_re = re.compile("""<TR BGCOLOR=#[A-F0-9]+><TD WIDTH=\d+%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^"]+">([^<]+)</A></TD><TD WIDTH=\d+%>(\d+)</TD><TD WIDTH=\d+%>([^<]+)</TD></TR>""")
    for a in row_re.finditer(html):
        assert len(a.groups()) == len(FIELDS)
        # generate a dict from a list of pairs,
        # with keys and values processed through FIELDS
        players.append(Character(**dict(
            [(FIELDS[b][0], FIELDS[b][1](a.group(b + 1)))
             for b in range(len(FIELDS))])))
    try:
        assert int(re.search(r"Currently (\d+) players are online\.", html).group(1)) == len(players)
    except AttributeError:
        assert len(players) == 0
    return stamp, players

def guild_list(world):
    html = http_get("/community/", {"subtopic": "guilds", "world": world})
    groups = re.findall(r'<INPUT TYPE=hidden NAME=GuildName VALUE="([^"]+)', html)
    retval = set()
    for guild in [set([x]) for x in groups]:
        assert len(guild) == 1
        assert retval.isdisjoint(guild)
        retval.update(guild)
    return retval

def guild_info(guild):
    html = http_get("/community/", {"subtopic": "guilds", "page": "view", "GuildName": guild})
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
