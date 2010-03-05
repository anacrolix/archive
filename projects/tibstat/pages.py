import calendar, contextlib, Cookie, gzip, io, itertools, os, pdb, shutil, time, urllib, urlparse, zlib

import dbiface, tibiacom
from htmldoc import HtmlDocument, tag

STANCES = (
        ("F", "friend"),
        ("A", "ally"),
        ("U", "unspec"),
        ("E", "enemy"),)
STANCE_VALUES = tuple(map(lambda t: t[0], STANCES))
STANCE_CSS_CLASS = dict(STANCES)

def char_link(name):
    return tag("a", name, attrs=dict(href=tibiacom.char_page_url(name)))

def guild_link(name, stance):
    return tag("a", name, attrs={"href": tibiacom.guild_members_url(name), "class": STANCE_CSS_CLASS[stance]})

class StandardPageContext(object):
    def __init__(self, request):
        #self.request = request
        a = urlparse.urlparse(request.path)
        self.path = a.path
        self.queries = urlparse.parse_qs(a.query)
        self.cookies = Cookie.SimpleCookie(request.headers.getheader("Cookie"))
    def get_guild_stance(self, guild):
        #pdb.set_trace()
        if "guildStance" in self.cookies:
            for a in self.cookies["guildStance"].value.split(","):
                b = a.split("|")
                if guild == b[0]:
                    return b[1]
        return "U"
    def get_selected_world(self):
        return self.queries.get("world", (None,))[0]
    def guild_link(self, guild):
        return guild_link(guild, self.get_guild_stance(guild))

def standard_page(request, title, content):
    context = StandardPageContext(request)
    body = io.BytesIO()
    sink = gzip.GzipFile(mode="wb", fileobj=body)
    #sink = body
    with standard_content_wrapper(sink.write, context, title) as outfile:
        content(outfile, context)
    #print request.headers.getheader("Accept-Encoding")
    request.send_response(200)
    request.send_header("Content-Type", "text/html")
    request.send_header("Content-Encoding", "gzip")
    request.end_headers()
    sink.close()
    body.seek(0)
    #request.wfile.write(zlib.compress(body.getvalue()))
    #assert not request.wfile.seekable()
    #assert request.wfile.tell() == 0
    shutil.copyfileobj(body, request.wfile)
    #assert request.wfile.tell() != 0

SKYSCRAPER_AD = '''<script type="text/javascript"><!--
google_ad_client = "pub-5195063250458873";
/* 160x600, created 3/1/10 */
google_ad_slot = "9047224765";
google_ad_width = 160;
google_ad_height = 600;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>'''

LINK_AD = '''<script type="text/javascript"><!--
google_ad_client = "pub-5195063250458873";
/* 728x15, created 3/1/10 */
google_ad_slot = "5533130493";
google_ad_width = 728;
google_ad_height = 15;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>'''

SEARCH_ENGINE = '''
<form action="http://www.google.com/cse" id="cse-search-box" target="_blank">
  <div>
    <input type="hidden" name="cx" value="partner-pub-5195063250458873:51atcrmvpus" />
    <input type="hidden" name="ie" value="ISO-8859-1" />
    <input type="text" name="q" size="16" />
    <input type="submit" name="sa" value="Search" />
  </div>
</form>
<script type="text/javascript" src="http://www.google.com/cse/brand?form=cse-search-box&amp;lang=en"></script>
'''

@contextlib.contextmanager
def standard_content_wrapper(write, context, title):
    """Add the HTML Document to the page context, ready for contents to be written to it, clean up afterwards."""

    #write('''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">''')
    doc = HtmlDocument(write)
    with doc.open_tag("html"):
        with doc.open_tag("head"):
            doc.add_tag(
                    "title",
                    "{0} - {1}".format(title, context.get_selected_world() or "All Worlds"),
                    inline=False)
            doc.add_tag("link", attrs=dict(rel="stylesheet", type="text/css", href="/tibstats.css"), inline=False)
            doc.add_tag("link", attrs=dict(rel="icon", type="image/gif", href="http://static.tibia.com/images/gameguides/skull_black.gif"), inline=False)
        with doc.open_tag("body", inline=False):
            with doc.open_tag("div", attrs={"style": "display: table; margin-left: auto; margin-right: auto"}):
                doc.writelns(LINK_AD.split("\n"))
            with doc.open_tag("div", attrs={"id": "container"}, inline=False):
                with doc.open_tag("div", {"id": "left"}, inline=False):
                    with doc.open_tag("div", {"id": "menu"}):
                        for path, entry in PAGES.iteritems():
                            if isinstance(entry, MenuPageEntry):
                                world = context.get_selected_world()
                                if world:
                                    path += "?" + urllib.urlencode({"world": world})
                                doc.add_tag("a", entry.title, attrs={"href": path})
                                doc.add_tag("br")
                        with doc.open_tag("form", attrs={"method": "get"}, inline=False):
                            doc.newline()
                            doc.add_tag("input", attrs=dict(type="submit", value="Set world"))
                            with doc.open_tag("select", attrs={"size": 1, "name": "world"}, inline=False):
                                def add_selected_world(world, attrs):
                                    if context.get_selected_world() == world:
                                        attrs["selected"] = None
                                    return attrs
                                doc.newline()
                                doc.add_tag("option", "All Worlds", attrs=add_selected_world(None, {"value": ""}))
                                for world in sorted(a["name"] for a in dbiface.get_worlds()):
                                    doc.newline()
                                    doc.add_tag("option", world, attrs=add_selected_world(world, {"value": world}))
                    with doc.open_tag("center"):
                        doc.writelns(SKYSCRAPER_AD.split("\n"))
                with doc.open_tag("div", attrs={"id": "center"}, inline=False):
                    yield doc
            with doc.open_tag("div", attrs={"style": "display: table; margin-left: auto; margin-right: auto"}):
                doc.writelns(SEARCH_ENGINE.split("\n"))

def stattab_table_tag(openTag):
    return openTag("table", attrs={"class": "stattab", "cellspacing": 1,})

def stattab_row_class():
    return itertools.cycle(("odd", "even"))

def human_time_diff(stamp):
    diff = dbiface.to_unixepoch(stamp) - int(time.time())
    assert isinstance(diff, int) # if this doesn't hold, we'll generate rubbish
    if diff == 0:
        return "now"
    if diff < 0:
        whence = "ago"
        diff = -diff # must be positive for identity: x == (x/y)*y +  (x%y)
    elif diff > 0:
        whence = "more"
    humanbits = []
    for divisor, units in ((60, "s"), (60, "min"), (24, "h"), (7, "d")):
        bitval = diff % divisor
        humanbits.append("%d%s" % (bitval, units) if bitval else None)
        diff //= divisor
        if diff == 0:
            break
    # take the 2 most significant bits, filter the zeroed ones
    return " ".join(filter(None, itertools.islice(reversed(humanbits), 2))) + " " + whence

def guild_stances(outfile, context):
    doc = outfile
    world = context.get_selected_world()
    with doc.open_tag("form", attrs={"method": "post",}): #"action": "/setcookie"}):
        with stattab_table_tag(doc.open_tag):
            with doc.open_tag("tr"):
                for heading in ("Guild Name",) + STANCE_VALUES:
                    doc.add_tag("th", heading)
                if not world:
                    doc.add_tag("th", "World")
            rowClass = stattab_row_class()
            for guild, guildWorld in dbiface.list_guilds():
                if not world or world == guildWorld:
                    with doc.open_tag("tr", attrs={"class": rowClass.next()}, inline=False):
                        doc.newline()
                        doc.add_tag("td", guild_link(guild, context.get_guild_stance(guild)))
                        for stance in STANCE_VALUES:
                            doc.newline()
                            with doc.open_tag("td", inline=True):
                                attrs = dict(type="radio", name=guild, value=stance)
                                if stance == context.get_guild_stance(guild):
                                    attrs["checked"] = None
                                doc.add_tag("input", attrs=attrs, inline=True)
                        if not world:
                            doc.add_tag("td", guildWorld)
#        doc.add_tag("input", attrs={"type": "hidden", "name": "NEXT_LOCATION", "value": "/whoisonline"})
        doc.add_tag("input", attrs={"type": "submit"})

def guild_stances_page(request, title):
    if request.command == "POST":
        # client POSTed, form a cookie, and set it, and then redirect them to nonPOST version
        contentLength = request.headers.getheader("Content-Length")
        postData = request.rfile.read(int(contentLength))
        guildStances = dict(urlparse.parse_qsl(postData, strict_parsing=True))
        cookie = Cookie.SimpleCookie()
        cookie["guildStance"] = ",".join("|".join(a) for a in guildStances.iteritems())
        cookie["guildStance"]["max-age"] = 7 * 24 * 60 * 60
        request.send_response(303) # See Other (GET)
        request.wfile.write(cookie.output() + '\r\n')
        # go back whence thee came
        request.send_header("Location", request.headers.getheader("Referer"))
        request.end_headers()
    else:
        standard_page(request, title, guild_stances)

def tibstats_stylesheet(request):
    #print request.headers
    with contextlib.closing(open("tibstats.css", "rb")) as f:
        fs = os.fstat(f.fileno())
        # variant modification time
        varmtime = request.headers.getheader("If-Modified-Since")
        if varmtime:
            # If-Modified-Since: Sat, 27 Feb 2010 16:13:49 GMT
            varmtime = calendar.timegm(time.strptime(varmtime, "%a, %d %b %Y %H:%M:%S %Z"))
            #print fs.st_mtime, varmtime
            if fs.st_mtime <= varmtime:
                request.send_response(304)
                request.end_headers()
                return
        request.send_response(200)
        request.send_header("Content-Type", "text/css")
        request.send_header("Content-Length", str(fs.st_size))
        request.send_header("Last-Modified", request.date_time_string(fs.st_mtime))
        request.end_headers()
        shutil.copyfileobj(f, request.wfile)

def recent_deaths(outfile, context):
    doc = outfile
    limits = (0, 100)
    world = context.get_selected_world()
    with stattab_table_tag(doc.open_tag):
        with doc.open_tag("tr"):
            for a in ("Time", "Deceased", "Level", "Killer", "Accomplices"):
                doc.add_tag("th", a)
            if not world:
                doc.add_tag("th", "World")
        killsIter = dbiface.get_last_deaths(limits, world=world)
        currentDeath = killsIter.next()
        killsEnded = False
        rowClass = stattab_row_class()
        while not killsEnded:
            with doc.open_tag("tr", attrs={"class": rowClass.next()}):
                doc.add_tag("td", human_time_diff(currentDeath["stamp"]))
                doc.add_tag("td", char_link(currentDeath["victim"]))
                doc.add_tag("td", currentDeath["level"])
                def make_killer(kill):
                    if kill["isplayer"]:
                        s = char_link(kill["killer"])
                    else:
                        s = kill["killer"]
                    return s
                data = [make_killer(currentDeath)]
                while True:
                    try:
                        nextKill = killsIter.next()
                    except StopIteration:
                        killsEnded = True
                        break
                    if (nextKill["stamp"], nextKill["victim"]) == (currentDeath["stamp"], currentDeath["victim"]):
                        a = make_killer(nextKill)
                        if nextKill["lasthit"]:
                            data.insert(0, a)
                        else:
                            data.append(a)
                    else:
                        #currentDeath = nextKill
                        nextDeath = nextKill
                        break
                doc.add_tag("td", data[0])
                doc.add_tag("td", ", ".join(data[1:]))
                if not world:
                    doc.add_tag("td", currentDeath["world"])
            currentDeath = nextDeath

def world_online(doc, pageContext):
    doc.newline()
    world = pageContext.get_selected_world()
    after = int(time.time()) - 300
    #after = 0
    onlineChars = dbiface.get_online_chars(after, world=world)
    doc.write("This page is still being optimized.<br>")
    doc.write("There are {0} players online.".format(len(onlineChars)))
    onlineChars.sort(key=lambda x: int(x["level"]), reverse=True)
    with doc.open_tag("table", {"class": "stattab"}):
        with doc.open_tag("tr"):
            doc.add_tag("th", "Name")
            doc.add_tag("th", "Level")
            doc.add_tag("th", "Vocation")
            doc.add_tag("th", "Guild")
            if not world:
                doc.add_tag("th", "World")
        rowClass = stattab_row_class()
        for char in onlineChars:
            doc.newline()
            with doc.open_tag("tr", attrs={"class": rowClass.next()}):
                doc.add_tag("td", char_link(char["name"]))
                for field in ("level", "vocation"):
                    doc.add_tag("td", data=str(char[field]))
                doc.add_tag("td", pageContext.guild_link(char["guild"]))
                if not world:
                    doc.add_tag("td", char["world"])

def pz_locked(doc, pageContext):
    world = pageContext.get_selected_world()
    curtime = int(time.time())
    limits = (0, 30)
    #limits = (0, 200)
    with stattab_table_tag(doc.open_tag):
        with doc.open_tag("tr", inline=False):
            if not world:
                doc.add_tag("th", "World")
            doc.add_tag("th", "PZ Lock End")
            doc.add_tag("th", "Killer")
            doc.add_tag("th", "Level")
            doc.add_tag("th", "Vocation")
            doc.add_tag("th", "Guild")
            doc.add_tag("th", "Last Victim")
        rowColor = stattab_row_class()
        for pzlock in dbiface.get_last_pzlocks(world, limits):
            killerInfo = dbiface.get_char(pzlock["killer"])
            if world is None or killerInfo["world"] == world:
                with doc.open_tag("tr", attrs={"class": rowColor.next()}, inline=False):
                    assert killerInfo["name"] == pzlock["killer"]
                    if not world:
                        doc.add_tag("td", killerInfo["world"])
                    doc.add_tag("td", human_time_diff(dbiface.pz_end(pzlock)))
                    doc.add_tag("td", char_link(pzlock["killer"]))
                    for field in ("level", "vocation"):
                        doc.add_tag("td", killerInfo[field])
                    doc.add_tag("td", pageContext.guild_link(killerInfo["guild"]))
                    doc.add_tag("td", char_link(pzlock["victim"]))

class PageEntry(object):
    def __init__(self, handler):
        self.handler = handler
    def handle_request(self, request):
        self.handler(request)

class MenuPageEntry(PageEntry):
    def __init__(self, handler, title):
        #pdb.set_trace()
        super(MenuPageEntry, self).__init__(handler)
        self.title = title
    def handle_request(self, request):
        self.handler(request, self.title)

class StandardPageEntry(MenuPageEntry):
    def __init__(self, handler, title):
        super(StandardPageEntry, self).__init__(handler, title)
    def handle_request(self, request):
        standard_page(request, self.title, self.handler)

PAGES = {
        "/guildstance": MenuPageEntry(guild_stances_page, "Guild Stances"),
        "/tibstats.css": PageEntry(tibstats_stylesheet),
        #"/tibstats-simple.css": PageEntry(tibstats_stylesheet),
        "/recentdeath": StandardPageEntry(recent_deaths, "Recent Deaths"),
        "/pzlocked": StandardPageEntry(pz_locked, "Protection Zone Locked"),
        "/whoisonline": StandardPageEntry(world_online, "Current Online"),}

def handle_http_request(request):
    try:
        basePath = request.path.split("?", 1)[0]
        if basePath in PAGES:
            PAGES[basePath].handle_request(request)
            return
        else:
            #request.send_error(404)
            request.send_response(302, "Default paths not set yet")
            request.send_header("Location", "/pzlocked")
            request.end_headers()
            return
    except:
        request.send_error(500, "Computer says no")
        raise
