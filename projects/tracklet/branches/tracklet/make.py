#!/usr/bin/env python

from pybake import *

import os
import re
import sys
import tempfile

CC = "g++"
OBJECTS = "main.o Applet.o RhythmboxProxy.o".split()
AUXCONFS = "control Makefile tracklet.server config.h".split()
# auxiliary conf files are made from corresponding .in file
AUXCONF_DEPS = map(lambda x: x + ".in", AUXCONFS)
# the package config dependencies
PCLIBS = "dbus-glib-1 gtk+-2.0 libpanelapplet-2.0".split()
PCLIB_LDFLAGS = Variable(["pkg-config", "--libs"] + PCLIBS)()
PCLIB_CFLAGS = Variable(["pkg-config", "--cflags"] + PCLIBS)()

link_step = BuildStep(lambda x, y: [CC, "-o", x[0]] + y + PCLIB_LDFLAGS.split())
compile_step = BuildStep(lambda x, y: [CC, "-c", "-o", x[0], y[0]] + PCLIB_CFLAGS.split())
configure_step = BuildStep(lambda x, y: ["./configure"])

symbols = [
    ("PREFIX", "/usr"),
    ("PACKAGE_VERSION", "0.2"),
    ("PACKAGE_REVISION", "0"),
    ("PACKAGE_NAME", "tracklet"),
    ("APPLET_FULLNAME", "Tracklet"),
    ("APPLET_DESCRIPTION", "Provides an icon to remove the current playing track from disk"),
    ("BONOBO_FACTORY_IID", "@BONOBO_APPLET_IID@_Factory"),
    ("BONOBO_APPLET_IID", "OAFIID:Tracklet"),
]

# BUILD_ARCH = `dpkg-architecture -qDEB_BUILD_ARCH`


def cpp_depgen(target):
    srcdep = re.sub("\.o$", ".cpp", target)
    makerule = Variable([CC, "-MM", "-MG", "-MT", target, srcdep])()
    maketargs, makedeps = buildsys.make.parse_rule(makerule)
    assert target in maketargs
    return maketargs, makedeps

binary = Relationship(["tracklet"], OBJECTS, link_step)
for auxconf in AUXCONFS:
    Relationship([auxconf], [auxconf + ".in"], Configure(symbols))
PatternRule(".*\.o$", compile_step, cpp_depgen)

Relationship.update_all()
