#!/usr/bin/env python

import os
import re
import sys
import tempfile

from pybake import *

CC = "g++"
OBJECTS = "main.o Applet.o RhythmboxProxy.o".split()
AUXCONFS = "control Makefile tracklet.server config.h".split()
# the package config dependencies
PCLIBS = "dbus-glib-1 gtk+-2.0 libpanelapplet-2.0".split()
PCLIB_LDFLAGS = SystemTask(["pkg-config", "--libs"] + PCLIBS)(stdout=True)#.strip("\n ")
PCLIB_CFLAGS = SystemTask(["pkg-config", "--cflags"] + PCLIBS)(stdout=True)#.strip("\n ")

link_step = BuildStep(lambda x, y: [CC, "-o", x[0]] + y + ["-g", "-Wall"] + PCLIB_LDFLAGS.split())
compile_step = BuildStep(lambda x, y: [CC, "-c", "-o", x[0], y[0], "-g", "-Wall"] + PCLIB_CFLAGS.split())
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
    makerule = SystemTask([CC, "-MM", "-MG", "-MT", target, srcdep])(stdout=True)
    maketargs, makedeps = buildsys.make.parse_rule(makerule)
    assert target in maketargs
    return maketargs, makedeps

binary = ExplicitRule(["tracklet"], OBJECTS, link_step)
for auxconf in AUXCONFS:
    ExplicitRule([auxconf], [auxconf + ".in"], Configure(symbols))
ImplicitRule(".*\.o$", compile_step, cpp_depgen)

bake()
