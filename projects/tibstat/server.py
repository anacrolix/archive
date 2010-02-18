#!/usr/bin/env python

import BaseHTTPServer, Cookie, urlparse, itertools, pdb, sys, time
sys.path.append("../tibdb")
import tibiacom

class TestHTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):

    def do_GET(self):

        self.select_page()

    def do_POST(self):

        self.select_page()

    def select_page(self):

        print self.headers

        self.online_list_page()

    def echo_stuff(self):

        self.send_response(200)
        #self.send_header("Content-type", "text/html")
        self.end_headers()
        for a in ("client_address", "command", "path", "request_version", "headers"):
            self.wfile.write("%s: %s\n" % (a, getattr(self, a)))
        self.wfile.close()

    def configure_guild_stances(self):

        contentLength = self.headers.getheader("content-length")
        if contentLength:
            postData = self.rfile.read(int(contentLength))
            guildStanceCookie = Cookie.SimpleCookie()
            for k, v in urlparse.parse_qsl(postData, strict_parsing=True):
                guildStanceCookie[k] = v
            self.send_response(303)
            self.wfile.write(guildStanceCookie.output() + '\r\n')
            self.send_header("location", self.path)
            self.end_headers()
            return
        else:
            guildStanceCookie = Cookie.SimpleCookie(self.headers.getheader("cookie"))
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        send = self.wfile.write
        #self.wfile.write(guildStanceCookie)
        #if self.command == 'POST':
        #    self.wfile.write(self.rfile.read())
        self.wfile.write('<form method="post">')
        self.wfile.write("<table>\n")
        listOfGuilds = ("Guild" + chr(ord("A") + n) for n in xrange(26))
        allowedStances = (("Unspecified", None), ("Allies", "blue"), ("Enemies", "red"), ("Friends", "green"))
        defaultStanceIndex = 0
        stanceColors = dict(allowedStances)
        self.wfile.write('<tr>')
        for caption in itertools.chain(("Guild Name",), (x[0] for x in allowedStances)):
            self.wfile.write('<th>{0}</th>'.format(caption))
        self.wfile.write('</tr>\n')
        #pdb.set_trace()
        for guildName in listOfGuilds:
            color = ''
            if guildName in guildStanceCookie:
                color = stanceColors[guildStanceCookie[guildName].value]
            self.wfile.write('<tr><td><font color="%s">%s</font></td>' % (color, guildName))
            for stanceIndex, (stanceName, stanceColor) in enumerate(allowedStances):
                checked = False
                if guildName in guildStanceCookie:
                    if guildStanceCookie[guildName].value == stanceName:
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

    def online_list_page(self):

        worldName = "Dolera"
        listTimestamp, worldOnlineChars = tibiacom.online_list(worldName)
        worldOnlineChars.sort(key=lambda x: x.level, reverse=True)

        self.send_response(200)
        self.send_header("Content-Type:", "text/html")
        self.end_headers()

        send = self.wfile.write

        send("<html><body>\n")

                #time.asctime(time.localtime(listTimestamp))
        send("There are {0} players on {1}<br>\n".format(len(worldOnlineChars), worldName))

        send("<table>\n")

        send("\t<tr>")
        COLUMNS = (
                ("name", "Character Name"),
                ("level", "Level"),
                ("vocation", "Vocation"),
                ("guild", "Guild"),)
        for col in COLUMNS:
            send("<th>{0}</th>".format(col[1]))
        send("</tr>\n")

        for char in worldOnlineChars:
            send("\t<tr>")
            for col in COLUMNS:
                value = getattr(char, col[0])
                send("<td>{0}</td>".format(value or ""))
            send("</tr>\n")
        send("</table>\n")

        send("</body></html>")

def run(server_class=BaseHTTPServer.HTTPServer,
        handler_class=TestHTTPRequestHandler):
    server_address = ('', 8000)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

run()
