#!/usr/bin/env python

import os
import re
import shutil
import sys

from pybake import *

CC = "g++"
OBJECTS = "main.o Applet.o RhythmboxProxy.o".split()
AUXCONFS = "control tracklet.server config.h".split()
# the package config dependencies
PCLIBS = "dbus-glib-1 gtk+-2.0 libpanelapplet-2.0".split()
PCLIB_LDFLAGS = SystemTask(["pkg-config", "--libs"] + PCLIBS)(stdout=True)#.strip("\n ")
PCLIB_CFLAGS = SystemTask(["pkg-config", "--cflags"] + PCLIBS)(stdout=True)#.strip("\n ")

link_step = BuildStep(lambda x, y: [CC, "-o", x[0]] + y + ["-g", "-Wall"] + PCLIB_LDFLAGS.split())
compile_step = BuildStep(lambda x, y: [CC, "-c", "-o", x[0], y[0], "-g", "-Wall"] + PCLIB_CFLAGS.split())
configure_step = BuildStep(lambda x, y: ["./configure"])

symbols = dict([
    ("PREFIX", "/usr"),
    ("PACKAGE_VERSION", "0.2"),
    ("PACKAGE_REVISION", "0"),
    ("PACKAGE_NAME", "tracklet"),
    ("APPLET_FULLNAME", "Tracklet"),
    ("APPLET_DESCRIPTION", "Provides an icon to remove the current playing track from disk"),
    ("BONOBO_FACTORY_IID", "@BONOBO_APPLET_IID@_Factory"),
    ("BONOBO_APPLET_IID", "OAFIID:Tracklet"),
    ("BUILD_ARCH", SystemTask(["dpkg-architecture", "-qDEB_BUILD_ARCH"])(stdout=True).strip()),
])

# i want *components here but it won't work?
def install(components, mode=None, target_not_dir=False, make_dirs=False, dir_first=False):
    args = ["install"]
    if mode != None: args.append("-m" + str(mode))
    if target_not_dir: args.append("-T")
    if make_dirs: args.append("-d")
    if dir_first: args.append("-t")
    args.extend(components)
    SystemTask(args)()

def install_target(prefix=None):
    if prefix == None: prefix = symbols["PREFIX"]
    server_path = os.path.join(prefix, "lib/bonobo/servers")
    applet_path = os.path.join(prefix, "lib/anacrolix")
    install([server_path, applet_path], make_dirs=True)
    install(["tracklet.server", server_path], mode=644)
    install([applet_path, "tracklet"], dir_first=True, mode=755)

def cpp_depgen(target):
    srcdep = re.sub("\.o$", ".cpp", target)
    makerule = SystemTask([CC, "-MM", "-MG", "-MT", target, srcdep])(stdout=True)
    maketargs, makedeps = buildsys.make.parse_rule(makerule)
    assert target in maketargs
    return maketargs, makedeps

def make_debpkg():
    shutil.rmtree("build", True)
    install_target("build")
    install(["build/DEBIAN"], make_dirs=True)
    install(["control", "build/DEBIAN"], mode=644)
    SystemTask(["dpkg", "-b", "build", "."])()

binary = ExplicitRule(["tracklet"], OBJECTS, link_step)
for auxconf in AUXCONFS:
    ExplicitRule([auxconf], [auxconf + ".in"], Configure(symbols))
ImplicitRule(".*\.o$", compile_step, cpp_depgen)

PhonyRule("clean", clean_targets)
#PhonyRule("install", install_target, ["tracklet", "tracklet.server"])
PhonyRule("debpkg", make_debpkg, ["tracklet", "tracklet.server", "control"])

pybake_main()
