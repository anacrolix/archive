#!/usr/bin/env python

import contextlib, Cookie, io, os, pdb, shutil, sys, time, urllib, urlparse

import dbiface, tibiacom
from htmldoc import HtmlDocument, tag

class PageContext(object):
    def __init__(self, request):
        self.request = request
        self.query = {}
        self.cookie = Cookie.SimpleCookie()
        self.htmldoc = HtmlDocument(self.request.wfile)
    def get_guild_stance(self, guild):
        #pdb.set_trace()
        if "guildStance" in self.cookie:
            for a in self.cookie["guildStance"].value.split(","):
                b = a.split("|")
                if guild == b[0]:
                    return b[1]
        return "U"
    def get_selected_world(self):
        return self.query.get("world", (None,))[0]
    def guild_link(self, guild):
        return guild_link(guild, self.get_guild_stance(guild))

STANCES = (
        ("F", "friend"),
        ("A", "ally"),
        ("U", "unspec"),
        ("E", "enemy"),)
STANCE_VALUES = tuple(map(lambda t: t[0], STANCES))
STANCE_CSS_CLASS = dict(STANCES)

PAGES = {}


@contextlib.contextmanager
def htmldoc_content_wrapper(pageContext, title):
    """Add the HTML Document to the page context, ready for contents to be written to it, clean up afterwards."""

    def setup_content_doc(pageContext, title):
        doc = pageContext.htmldoc
        doc.start_head()
        doc.add_tag("title", title, inline=False)
        doc.add_tag("link", attrs=dict(rel="stylesheet", type="text/css", href="/tibstats.css"), inline=False)
        doc.add_tag("link", attrs=dict(rel="icon", type="image/gif", href="http://static.tibia.com/images/gameguides/skull_black.gif"), inline=False)
        doc.start_body()
        with doc.open_tag("div", {"id": "menu"}):
            for p in PAGES.values():
                try:
                    title = p.baseTitle
                except AttributeError:
                    continue
                path = p.basePath
                world = pageContext.get_selected_world()
                if world:
                    path += "?" + urllib.urlencode({"world": world})
                doc.add_tag("a", title, attrs={"href": path})
                doc.add_tag("br")
            with doc.open_tag("form", attrs={"method": "get"}):
                doc.add_tag("input", attrs=dict(type="submit", value="Set world"))
                with doc.open_tag("select", attrs={"size": 1, "name": "world"}):
                    def add_selected_world(world, attrs):
                        if pageContext.get_selected_world() == world:
                            attrs["selected"] = None
                        return attrs
                    doc.add_tag("option", "ALL WORLDS", attrs=add_selected_world(None, {"value": ""}))
                    for world in sorted(a["name"] for a in dbiface.get_worlds()):
                        doc.add_tag("option", world, attrs=add_selected_world(world, {"value": world}))
        doc.open_tag("div", {"id": "content"}, inline=False)
        return doc

    def finish_doc_content(doc):
        doc.close_tag("div", inline=False)
        doc.close()

    setup_content_doc(pageContext, title)
    yield
    finish_doc_content(pageContext.htmldoc)

class PageGenerator(object):
    def __init__(self, contentFunc, basePath, baseTitle=None):
        self.basePath = basePath
        self.contentFunc = contentFunc
        if baseTitle:
            self.baseTitle = baseTitle
    def generate_page(self, requestHandler):
        return self.contentFunc(requestHandler)

class StandardPage(PageGenerator):
    """Generates menus etc., and jumps into the content function ready for the main data"""
    def __init__(self, contentFunc, basePath, baseTitle, allowedMethods=("GET",)):
        super(self.__class__, self).__init__(contentFunc, basePath, baseTitle=baseTitle)
        self.allowedMethods = allowedMethods
    def generate_page(self, requestHandler):
        """Overrides and wraps a content function that generates data, and takes a page context."""
        rh = requestHandler
        if rh.command not in self.allowedMethods:
            rh.send_response(405, "Computer says no")
            rh.send_header("Allow", ", ".join(self.allowedMethods))
            rh.end_headers()
            return
        rh.send_response(200)
        rh.send_header("Content-Type", "text/html")
        rh.end_headers()

        pageContext = PageContext(rh)
        parseResult = urlparse.urlparse(rh.path)
        pageContext.path = parseResult.path
        pageContext.query = urlparse.parse_qs(parseResult.query)
        pageContext.cookie = Cookie.SimpleCookie(rh.headers.getheader("Cookie"))

        with htmldoc_content_wrapper(pageContext, self.baseTitle):
            self.contentFunc(pageContext)

def register_page(pageClass, basePath, *args, **kwargs):
    def _1(contentFunc):
        a = pageClass(contentFunc, basePath, *args, **kwargs)
        assert basePath not in PAGES
        PAGES[basePath] = a
    return _1

@register_page(StandardPage, "/whoisonline", "Players Online")
def world_online(pageContext):
    doc = pageContext.htmldoc
    doc.newline()
    world = pageContext.get_selected_world()
    after = int(time.time()) - 300
    #after = 0
    onlineChars = dbiface.get_online_chars(after, world=world)
    doc.write("There are {0} players online.".format(len(onlineChars)))
    onlineChars.sort(key=lambda x: int(x["level"]), reverse=True)
    with doc.open_tag("table"):
        with doc.open_tag("tr"):
            doc.add_tag("th", "Name")
            doc.add_tag("th", "Level")
            doc.add_tag("th", "Vocation")
            doc.add_tag("th", "Guild")
            if not world:
                doc.add_tag("th", "World")
        for char in onlineChars:
            doc.newline()
            with doc.open_tag("tr"):
                doc.add_tag("td", char_link(char["name"]))
                for field in ("level", "vocation"):
                    doc.add_tag("td", data=str(char[field]))
                doc.add_tag("td", pageContext.guild_link(char["guild"]))
                if not world:
                    doc.add_tag("td", char["world"])

def char_link(name):
    return tag("a", name, attrs=dict(href=tibiacom.char_page_url(name)))

def guild_link(name, stance):
    return tag("a", name, attrs={"href": tibiacom.guild_members_url(name), "class": STANCE_CSS_CLASS[stance]})

@register_page(StandardPage, "/pzlocked", "Players with PZL")
def pz_locked(pageContext):
    curtime = int(time.time())
    #curtime = 1267240000
    world = pageContext.get_selected_world()
    doc = pageContext.htmldoc
    with doc.open_tag("table"):
        with doc.open_tag("tr", inline=False):
            if not world:
                doc.add_tag("th", "World")
            doc.add_tag("th", "PZL left")
            doc.add_tag("th", "Killer")
            doc.add_tag("th", "Level")
            doc.add_tag("th", "Vocation")
            doc.add_tag("th", "Guild")
            doc.add_tag("th", "Last Victim")
        for pzlock in dbiface.get_pzlocks(curtime=curtime):
            killerInfo = dbiface.get_char(pzlock["killer"])
            if world is None or killerInfo["world"] == world:
                with doc.open_tag("tr", inline=False):
                    assert killerInfo["name"] == pzlock["killer"]
                    if not world:
                        doc.add_tag("td", killerInfo["world"])
                    doc.add_tag("td", "{0} mins".format((dbiface.pz_end(pzlock) - curtime) // 60))
                    doc.add_tag("td", char_link(pzlock["killer"]))
                    for field in ("level", "vocation"):
                        doc.add_tag("td", killerInfo[field])
                    doc.add_tag("td", pageContext.guild_link(killerInfo["guild"]))
                    doc.add_tag("td", char_link(pzlock["victim"]))

@register_page(PageGenerator, "/guildstances", baseTitle="Guild Stances")
def guild_stances(request):
    contentLength = request.headers.getheader("Content-Length")
    if contentLength:
        if request.path.startswith("/guildstance"):
            # client POSTed, form a cookie, and set it, and then redirect them to nonPOST version
            postData = request.rfile.read(int(contentLength))
            guildStances = dict(urlparse.parse_qsl(postData, strict_parsing=True))
            cookie = Cookie.SimpleCookie()
            cookie["guildStance"] = ",".join("|".join(a) for a in guildStances.iteritems())
            request.send_response(303) # See Other (GET)
            request.wfile.write(cookie.output() + '\r\n')
            request.send_header("Location", self.headers.getheader("Referer"))
            request.end_headers()
            return
    doc = context.htmldoc
    world = context.get_selected_world()
    with doc.open_tag("form", attrs={"method": "post",}): #"action": "/setcookie"}):
        with doc.open_tag("table"):
            with doc.open_tag("tr"):
                for heading in ("Guild Name",) + STANCE_VALUES:
                    doc.add_tag("th", heading)
                if not world:
                    doc.add_tag("th", "World")
            for guild, guildWorld in dbiface.list_guilds():
                if not world or world == guildWorld:
                    with doc.open_tag("tr", inline=False):
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

@register_page(StandardPage, "/recentdeath", "Recent Deaths")
def recent_deaths(context):
    doc = context.htmldoc
    limits = (0, 100)
    with doc.open_tag("table"):
        with doc.open_tag("tr"):
            for a in ("Time", "Deceased", "Level", "Killer", "Accomplices"):
                doc.add_tag("th", a)
        killsIter = dbiface.get_last_deaths(limits)
        currentDeath = killsIter.next()
        killsEnded = False
        while not killsEnded:
            with doc.open_tag("tr"):
                doc.add_tag("td", currentDeath["stamp"])
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
                        currentDeath = nextKill
                        break
                doc.add_tag("td", data[0])
                doc.add_tag("td", ", ".join(data[1:]))

@register_page(PageGenerator, "/tibstats.css")
def tibstats_stylesheet(requestHandler):
    f = open("tibstats.css", "rb")
    fs = os.fstat(f.fileno())
    requestHandler.send_response(200)
    requestHandler.send_header("Content-Type", "text/css")
    requestHandler.send_header("Content-Length", str(fs.st_size))
    requestHandler.send_header("Last-Modified", requestHandler.date_time_string(fs.st_mtime))
    requestHandler.end_headers()
    shutil.copyfileobj(f, requestHandler.wfile)
    f.close()

def generate_http_response(requestHandler):

    basePath = requestHandler.path.split("?", 1)[0]
    try:
        pageGen = PAGES[basePath]
    except KeyError:
        requestHandler.send_response(404, "Path not yet implemented")
        requestHandler.send_header("Location", "/pzlocked")
        requestHandler.end_headers()
    else:
        return pageGen.generate_page(requestHandler)

if __name__ == "__main__":
    context = PageContext()
    context.content = sys.stdout
    #context.content = open("/dev/null", "wb")
    globals()[sys.argv[1]](context)
