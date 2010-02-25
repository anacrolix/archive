import htmlentitydefs, re, time
from .types import Character, CharDeath, Killer

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

STR = r"<tr[^>]*>"
ETR = r"</tr>"
STD = r"<td[^>]*>"
ETD = r"</td>"
TIBTIME = r"([^<]+)"
LEVEL = r".*?at Level (\d+) by "
KILLERS = r"(.*?)"

def char_page_deaths(html):
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

def char_page(html, name):
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
                "<TR.*?><TD.*?>{0}:</TD><TD>([^<]+?)</TD></TR>".format(field),
                html)
        if len(hits) == 0:
            assert not required, "Character page for %r: Required field %s not found" % (charname, field)
            info[key] = None
        elif len(hits) == 1:
            info[key] = transform(hits[0]) if transform != None else hits[0]
        else:
            assert False, "Too many hits for field"
    assert info["name"] == name

    info["deaths"] = char_page_deaths(html)

    return info

def world_online(html):
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
    return players

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
