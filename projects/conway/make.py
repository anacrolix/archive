#!/usr/bin/env python

import os

from pybake import *

if os.name == 'nt':
    import pybake.compiler.msvc as cxx
    DEFINES = ["BOOST_ALL_DYN_LINK"]
    INCLUDES = [r"C:\Boost\include\boost-1_38", "win32/include"]
    LIBPATHS = [r"C:\Boost\lib"]
    OBJECTS = ["main.obj", "win32/lib/SDL.lib", "win32/lib/SDLmain.lib"]
    OBJSUFF = ".obj"
else:
    import pybake.compiler.gcc.cxx as cxx
    sdl_config = LibraryConfig("sdl-config")
    CFLAGS = sdl_config(["--cflags"])
    LDFLAGS = sdl_config(["--libs"]) + cxx.libflag("boost_thread-mt")

cxx.executable("conway", ["main.cpp"], CFLAGS, LDFLAGS)

PhonyRule("clean", clean_targets)

pybake_main()
