#!/usr/bin/env python

from pybake import *
import pybake.lang.cxx.gcc as cxx
import glob

gtest = LibraryConfig("gtest-config")
CXXFLAGS = ["-Wall", "-O3"] + gtest(["--cxxflags"])
LDFLAGS = gtest(["--libs"]) + ["-lboost_system-mt"]
cxx.executable("benchmark", glob.glob("src/*.cc"), CXXFLAGS, LDFLAGS)

pybake_main()
