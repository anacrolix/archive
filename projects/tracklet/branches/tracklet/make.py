#!/usr/bin/env python

import os
import shutil
import sys

from pybake import *

symbols = {
    "PREFIX": "/usr",
    "PACKAGE_VERSION": "0.2",
    "PACKAGE_REVISION": "0",
    "PACKAGE_NAME": "tracklet",
    "APPLET_FULLNAME": "Tracklet",
    "APPLET_DESCRIPTION": "Provides an icon to remove the current playing track from disk",
    "BONOBO_FACTORY_IID": "@BONOBO_APPLET_IID@_Factory",
    "BONOBO_APPLET_IID": "OAFIID:Tracklet",
    "BUILD_ARCH": SystemTask(["dpkg-architecture", "-qDEB_BUILD_ARCH"])(stdout=True).strip()
}
configure_step = BuildStep(lambda x, y: ["./configure"])
for auxconf in "control tracklet.server config.h".split():
    ExplicitRule([auxconf], [auxconf + ".in"], Configure(symbols))

import pybake.lang.cxx.gcc as cxx
pkg_config = LibraryConfig("pkg-config", "dbus-glib-1 gtk+-2.0 libpanelapplet-2.0".split())
CFLAGS = ["-g", "-Wall"] + pkg_config(["--cflags"])
LDFLAGS = pkg_config(["--libs"])
cxx.executable("tracklet", "main.cpp Applet.cpp RhythmboxProxy.cpp".split(), CFLAGS, LDFLAGS)

install = Install(prefix=symbols["PREFIX"])
install.file("tracklet.server", "lib/bonobo/servers")
install.file("tracklet", "lib/anacrolix", executable=True)

def make_debpkg():
    shutil.rmtree("build", True)
    install(prefix="build")
    functions.install(["build/DEBIAN"], make_dirs=True)
    functions.install(["control", "build/DEBIAN"], mode=644)
    SystemTask(["dpkg", "-b", "build", "."])()

PhonyRule("install", install, install.prereqs())
PhonyRule("debpkg", make_debpkg, install.prereqs() + ["control"])

pybake_main()
