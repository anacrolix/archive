#!/usr/bin/python

import sys
sys.path.append("build")
from build import *

# this is really good bit...
if os.name == 'posix':
    CC = "g++"
else:
    assert False

OBJECTS = "main.o Applet.o RhythmboxProxy.o".split(" ")
AUXCONFS = "control symbols Makefile tracklet.server config.h".split(" ")
AUXCONF_DEPS = map(lambda x: x + ".in", AUXCONFS)
PCLIBS = "dbus-glib-1 gtk+-2.0 libpanelapplet-2.0"
PCLIB_LDFLAGS = BuildVariable(["pkg-config", "--libs", PCLIBS], shell=False)
PCLIB_CFLAGS = BuildVariable(["pkg-config", "--cflags", PCLIBS], shell=False)

link_step = BuildStep(lambda x, y: [CC, PCLIB_LDFLAGS, "-o", x[0]] + y)
compile_step = BuildStep(lambda x, y: [CC, PCLIB_CFLAGS, "-c", "-o", x[0], y[0]])
configure_step = BuildStep(lambda x, y: ["./configure"])

binary = Relationship(["tracklet"], OBJECTS, link_step)
auxconf = Relationship(AUXCONFS, AUXCONF_DEPS, configure_step)
PatternRule("\.o$", ".cpp", compile_step)

auxconf.update()
binary.update()

print AUXCONF_DEPS
print "FINISH"
