#!/usr/bin/env python

SERVER_FILE = "tracklet.server.in"

import xml.dom.minidom as dom
import os, os.path as path

server = dom.parse("GNOME_PythonAppletSample.server")
assert server.documentElement.tagName == 'oaf_info'
for child in server.documentElement.childNodes:
    if child.nodeType != child.ELEMENT_NODE: continue
    if child.tagName != u"oaf_server": continue
    if child.getAttribute("type") != "exe": continue
    child.setAttribute("location", path.join(os.getcwd(), "applet.py"))

print server.writexml(
        open("GNOME_PythonAppletSample.server", "w"))

import subprocess
subprocess.check_call(["activation-client", "--add-path", os.getcwd()])
