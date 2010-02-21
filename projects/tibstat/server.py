#!/usr/bin/env python

import BaseHTTPServer, Cookie, urlparse, itertools, pdb, sys, time
sys.path.append("../tibdb")
import dbiface, tibiacom

STANCES = (
        ("Unspecified", ""),
        ("Friend", "green"),
        ("Ally", "blue"),
        ("Enemy", "red"),)

def get_stance_color(stance):
    return dict(STANCES).get(stance, "")

class TestHTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):

    def do_GET(self):

        self.select_page()

    def do_POST(self):

        self.select_page()

    def select_page(self):

        print self.headers

        if self.path == "/whoisonline":
            self.online_list_page()
        elif self.path == "/guildstance":
            self.configure_guild_stances()

    def echo_stuff(self):

        self.send_response(200)
        #self.send_header("Content-type", "text/html")
        self.end_headers()
        for a in ("client_address", "command", "path", "request_version", "headers"):
            self.wfile.write("%s: %s\n" % (a, getattr(self, a)))
        self.wfile.close()

    def configure_guild_stances(self):

        contentLength = self.headers.getheader("Content-Length")
        if contentLength:
            # client POSTed, form a cookie, and set it, and then redirect them to nonPOST version
            postData = self.rfile.read(int(contentLength))
            guildStances = dict(urlparse.parse_qsl(postData, strict_parsing=True))
            cookie = Cookie.SimpleCookie()
            cookie["guildStances"] = guildStances
            self.send_response(303)
            self.wfile.write(cookie.output() + '\r\n')
            self.send_header("Location", "/whoisonline")
            self.end_headers()
            return

        # read existing stances from cookie
        guildStances = self.get_guild_stances()
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.end_headers()

        send = self.wfile.write

        send('<form method="post">')
        send("<table>\n")
        listOfGuilds = dbiface.list_guilds()
        allowedStances = STANCES
        defaultStanceIndex = 0
        stanceColors = dict(allowedStances)
        self.wfile.write('<tr>')
        for caption in itertools.chain(("Guild Name",), (x[0] for x in allowedStances)):
            self.wfile.write('<th>{0}</th>'.format(caption))
        self.wfile.write('</tr>\n')
        #pdb.set_trace()
        for guildName in listOfGuilds:
            color = ''
            if guildName in guildStances:
                color = get_stance_color(guildStances[guildName])
            send('<tr><td><font color="%s">%s</font></td>' % (color, guildName))
            for stanceIndex, (stanceName, stanceColor) in enumerate(allowedStances):
                checked = False
                if guildName in guildStances:
                    if guildStances[guildName] == stanceName:
                        checked = True
                elif stanceIndex == defaultStanceIndex:
                    checked = True
                extraAttrs = ""
                if checked:
                    extraAttrs += " checked"
                send('<td><input type="radio" name="{0}" value="{1}"{2}></td>'.format(guildName, stanceName, extraAttrs))
            self.wfile.write('</tr>\n')
        self.wfile.write("</table>")
        self.wfile.write('<input type="submit">')
        self.wfile.write('</form>')

    def get_guild_stances(self):

        cookie = Cookie.SimpleCookie(self.headers.getheader("Cookie"))
        try:
            guildStancesValue = cookie["guildStances"]
        except KeyError:
            return {}
        else:
            return eval(guildStancesValue.value)

    def online_list_page(self):

        worldName = "Dolera"
        listTimestamp, worldOnlineChars = tibiacom.online_list(worldName)
        worldOnlineChars.sort(key=lambda x: x.level, reverse=True)

        self.send_response(200)
        self.send_header("Content-Type:", "text/html")
        self.end_headers()

        send = self.wfile.write

        send("<html><body>\n")

        send("<pre>")
        send("</pre>")

                #time.asctime(time.localtime(listTimestamp))
        send("There are {0} players on {1}.".format(len(worldOnlineChars), worldName))
        send(' <a href="/guildstance">Click here</a> to configure guild stances<br>\n')

        send("<table>\n")

        send("\t<tr>")

        def get_char_guild_cell(char):
            charRow = dbiface.get_char(char.name)
            if charRow is not None:
                guild = charRow["guild"]
                return "<font color=\"%s\">%s</font>" % (
                        dict(STANCES).get(self.get_guild_stances().get(guild)), guild)

        COLUMNS = (
                ("name", "Character Name", None),
                ("level", "Level", None),
                ("vocation", "Vocation", None),
                ("guild", "Guild", get_char_guild_cell),)
        for col in COLUMNS:
            send("<th>{0}</th>".format(col[1]))
        send("</tr>\n")

        #guildNameGenerator = ("Guild" + chr(ord("A") + n) for n in itertools.cycle(xrange(26)))
        for char in worldOnlineChars:
            send("\t<tr>")
            for col in COLUMNS:
                if col[2] is None:
                    value = getattr(char, col[0])
                else:
                    value = col[2](char)
                send("<td>{0}</td>".format(value or ""))
            send("</tr>\n")
        send("</table>\n")

        send("</body></html>")

def run(server_class=BaseHTTPServer.HTTPServer,
        handler_class=TestHTTPRequestHandler):
    server_address = ('', 17021)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

run()
