#!/usr/bin/env python

import sys
sys.path.append('../../utility')
from pybake import *
import pybake.lang.cxx.gcc as cxx
from glob import glob

gtest = LibraryConfig("gtest-config")
python = LibraryConfig("python-config")
FLAGS = ["-O2", "-g"]
CXXFLAGS = gtest(["--cxxflags"]) + python(["--includes"]) + ["-Wall"] + FLAGS
LDFLAGS = gtest(["--libs"]) + python(["--libs"]) + ["-lboost_system-mt"] + FLAGS
cxx.executable("benchmark", glob("src/*.cc") + glob("src/*.cpp"), CXXFLAGS, LDFLAGS)

pybake_main()
