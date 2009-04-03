#!/usr/bin/env python

import sys
sys.path.append("..")
from build import *

obj_a = Relationship(["demo_a.o"], ["demo_a.c"], lambda x, y: "gcc -o " + x[0] + " -c " + y[0])
obj_b = Relationship(["demo_b.o"], ["demo_b.c"], lambda x, y: "gcc -o " + x[0] + " -c " + y[0])
exe = Relationship(["demo"], ["demo_a.o", "demo_b.o"], lambda x, y: " ".join(["gcc -o", x[0], " ".join(y)]))

exe.update()

clean()
print "FINISH"
