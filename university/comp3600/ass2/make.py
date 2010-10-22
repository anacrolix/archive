#!/usr/bin/env python

from subprocess import *
check_call(["/usr/bin/gcc", "-o", "minst", "minst.c", "-lm", "-g", "-O4", "-DNDEBUG",
        "-Wall",
        "-std=gnu99",
        "-Wextra",
        "-Wfloat-equal",
        "-fdiagnostics-show-option",
        "-Werror=return-type",
        "-Werror-implicit-function-declaration",
        "-Winline",
        "-Wshadow",
        "-Wmissing-format-attribute",
        "-save-temps",
    ])
