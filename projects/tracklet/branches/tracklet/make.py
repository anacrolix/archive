#!/usr/bin/env python

import sys
sys.path.append("pybuild")
from pybuild import *

CC = "g++"
OBJECTS = "main.o Applet.o RhythmboxProxy.o".split()
AUXCONFS = "control symbols Makefile tracklet.server config.h".split()
# auxiliary conf files are made from corresponding .in file
AUXCONF_DEPS = map(lambda x: x + ".in", AUXCONFS)
# the package config dependencies
PCLIBS = "dbus-glib-1 gtk+-2.0 libpanelapplet-2.0".split()
PCLIB_LDFLAGS = Variable(["pkg-config", "--libs"] + PCLIBS)()
PCLIB_CFLAGS = Variable(["pkg-config", "--cflags"] + PCLIBS)()

link_step = BuildStep(lambda x, y: [CC, "-o", x[0]] + y + PCLIB_LDFLAGS.split())
compile_step = BuildStep(lambda x, y: [CC, "-c", "-o", x[0], y[0]] + PCLIB_CFLAGS.split())
configure_step = BuildStep(lambda x, y: ["./configure"])
def cpp_depgen(target):
    srcdep = re.sub("\.o$", ".cpp", target)
    makerule = Variable([CC, "-MM", "-MG", "-MT", target, srcdep])()
    maketargs, makedeps = parse_make_rule(makerule)
    assert target in maketargs
    return maketargs, makedeps

binary = Relationship(["tracklet"], OBJECTS, link_step)
auxconf = Relationship(AUXCONFS, AUXCONF_DEPS, configure_step)
PatternRule(".*\.o$", compile_step, cpp_depgen)

binary.update_all()
