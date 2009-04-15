import os
import re

from pybake import *

if os.name == 'nt':
	from compiler import msvc as cxx
else:
	import compiler.gcc.c

INCLUDES = [r"C:\Boost\include\boost-1_38"]

LIBPATHS = [r"C:\Boost\lib"]
LIBOBJS = ["SDL", "SDLmain"]


link_step = msvc.Linker(libpaths=["win32/lib"]+LIBS)
compile_step = msvc.Compiler(includes=["win32/include"]+INCLUDE, defines=["BOOST_ALL_DYN_LINK"])

ExplicitRule(["conway.exe"], ["main.obj", "win32/lib/SDL.lib", "win32/lib/SDLmain.lib"], link_step)
ImplicitRule(".*\.obj$", compile_step, lambda targ: ([targ], [re.sub("\.obj$", ".cpp", targ)]))

PhonyRule("clean", clean_targets)

pybake_main()