#!/usr/bin/env python

import sys
sys.path.append("..")
from build import *

# this is really good bit...
if os.name == 'posix':
    CC = "gcc"
else:
    assert False

OBJECTS = "demo_a.o demo_b.o".split(" ")

compile_step = BuildStep(lambda x, y: [CC, "-c -Wall -o", x[0], y[0]], shell=True)
PatternRule("\.o$", ".c", compile_step)

binary = Relationship(["demo"], OBJECTS, BuildStep(lambda x, y: [CC, "-o", x[0]] + y))

binary.update()
