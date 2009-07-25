#!/usr/bin/env python

from pybake import *
import pybake.lang.cxx.gcc as cxx
from glob import glob

gtest = LibraryConfig("gtest-config")
python = LibraryConfig("python-config")
CXXFLAGS = gtest(["--cxxflags"]) + python(["--includes"]) + ["-Wall", "-O2", "-g"]
LDFLAGS = gtest(["--libs"]) + python(["--libs"]) + ["-lboost_system-mt", "-O2", "-g"]
cxx.executable("benchmark", glob("src/*.cc") + glob("src/*.cpp"), CXXFLAGS, LDFLAGS)

pybake_main()
