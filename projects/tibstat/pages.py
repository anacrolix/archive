#!/usr/bin/env python

import contextlib, Cookie, io, os, pdb, shutil, sys, time, urllib, urlparse

import dbiface, tibiacom
from htmldoc import HtmlDocument, tag

class PageContext(object):
    def __init__(self, outfile):
        self.query = {}
        self.cookie = Cookie.SimpleCookie()
        self.htmldoc = HtmlDocument(outfile)
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
    def __init__(self, contentFunc, basePath):
        self.basePath = basePath
        self.contentFunc = contentFunc
    def __call__(self, requestHandler):
        return self.contentFunc(requestHandler)

class StandardPage(PageGenerator):
    def __init__(self, contentFunc, basePath, baseTitle):
        super(self.__class__, self).__init__(contentFunc, basePath)
        self.baseTitle = baseTitle
    def __call__(self, requestHandler):
        requestHandler.send_response(200)
        requestHandler.send_header("Content-Type", "text/html")
        requestHandler.end_headers()

        pageContext = PageContext(outfile=requestHandler.wfile)
        parseResult = urlparse.urlparse(requestHandler.path)
        pageContext.path = parseResult.path
        pageContext.query = urlparse.parse_qs(parseResult.query)
        del parseResult
        pageContext.cookie = Cookie.SimpleCookie(requestHandler.headers.getheader("Cookie"))
        #pageContext.content = requestHandler.wfile

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

@register_page(StandardPage, "/guildstances", "Guild Stances")
def guild_stances(context):
    world = context.query.get("world", (None,))[0]
    doc = setup_content_doc(context, "Guild Stances for {0}".format(world or "all worlds"))
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
    finish_doc_content(doc)

@register_page(StandardPage, "/recentdeath", "Recent Deaths")
def recent_deaths(context):
    doc = context.htmldoc
    doc.add_tag("h1", "HELLO WORLD")

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

#SIMPLE_PAGES = (
        #("/whoisonline", world_online),
        #("/pzlocked", pz_locked),
        #("/guildstance", guild_stances),
        #("/recentdeath", recent_deaths),
        #("/tibstats.css", tibstats_stylesheet),)
#PATH_TO_SIMPLE_PAGE = dict(((x[0], x) for x in SIMPLE_PAGES))

def generate_http_response(requestHandler):
    #parseResult = urlparse.urlparse(requestHandler.path)
    #path = parseResult.path
    #query = urlparse.parse_qs(parseResult.query)
    #del parseResult

    basePath = requestHandler.path.split("?", 1)[0]
    pageParams = PAGES[basePath]
    pageParams(requestHandler)

    #simplePages = {
            #"/whoisonline": pages.world_online,
            #"/pzlocked": pages.pz_locked,
            #"/guildstance": pages.guild_stances,}
    #try:
        #pageFunc = simplePages[path]
    #except KeyError:
        #pass
    #else:
        #context = PageContext()
        #context.query = query
        #context.cookie = Cookie.SimpleCookie(self.headers.getheader("Cookie"))
        ##print context.cookie
        #context.content = io.BytesIO()
        #pageFunc(context)
        #self.send_response(200)
        #self.send_header("Content-Type", "text/html")
        #self.end_headers()
        #context.content.seek(0)
        #shutil.copyfileobj(context.content, self.wfile)
        #return


    #self.send_response(301, "Path not yet implemented")
    #self.send_header("Location", "/pzlocked")
    #self.end_headers()

#def do_POST(self):

    #contentLength = self.headers.getheader("Content-Length")
    #if contentLength:
        #if self.path.startswith("/guildstance"):
            ## client POSTed, form a cookie, and set it, and then redirect them to nonPOST version
            ##pdb.set_trace()
            #postData = self.rfile.read(int(contentLength))
            #guildStances = dict(urlparse.parse_qsl(postData, strict_parsing=True))
            #cookie = Cookie.SimpleCookie()
            #cookie["guildStance"] = ",".join("|".join(a) for a in guildStances.iteritems())
            #self.send_response(303)
            #self.wfile.write(cookie.output() + '\r\n')
            #try:
                #self.send_header("Location", guildStances.pop("NEXT_LOCATION"))
            #except KeyError:
                #self.send_header("Location", self.headers.getheader("Referer"))
            #self.end_headers()
            #return

    #self.send_response(301, "Path not yet implemented")
    #self.send_header("Location", "/pzlocked")
    #self.end_headers()

if __name__ == "__main__":
    context = PageContext()
    context.content = sys.stdout
    #context.content = open("/dev/null", "wb")
    globals()[sys.argv[1]](context)
