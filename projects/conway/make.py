#!/usr/bin/env python

import os

from pybake import *

CFLAGS = []
LDFLAGS = []

if os.name == 'nt':
    import pybake.compiler.msvc as cxx
    CFLAGS += cxx.define("BOOST_ALL_DYN_LINK")
    CFLAGS += cxx.include(r"C:\Boost\include\boost-1_38", r"win32/include")
    LDFLAGS += cxx.libpath(r"C:\Boost\lib")
    LDFLAGS += cxx.library("win32/lib/SDL", "win32/lib/SDLmain")
else:
    import pybake.lang.cxx.gcc as cxx
    sdl_config = LibraryConfig("sdl-config")
    CFLAGS = sdl_config(["--cflags"])
    LDFLAGS = sdl_config(["--libs"]) + cxx.library("boost_thread-mt")

cxx.executable("conway", ["main.cpp"], CFLAGS, LDFLAGS)

pybake_main()
