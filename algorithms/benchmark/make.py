#!/usr/bin/env python

import errno, os, threading, subprocess

__jobSemaphore = threading.BoundedSemaphore(1)
__targets = {}

class PybakeError(Exception):
    pass

def add_rule(outputs, inputs, commands):
    for o in outputs:
        assert not o in __targets
        __targets[o] = (outputs, inputs, commands)

def is_outdated(target, deps):
    #print "is_outdated(", target, deps, ")"
    try:
        targetMtime = os.stat(target).st_mtime
    except OSError as e:
        if e.errno == errno.ENOENT:
            return True
        else:
            raise
    for d in deps:
        if os.stat(d).st_mtime > targetMtime:
            return True
    else:
        return False

class Command(object):
    pass

class ShellCommand(Command):
    def __init__(self, *args):
        self.args = args
    def __call__(self):
        print subprocess.list2cmdline(self.args)
        subprocess.check_call(self.args)

def update(target):
    rule = __targets[target]
    ts = []
    for i in rule[1]:
        if i in __targets:
            ts.append(threading.Thread(target=update, name=i, args=[i]))
            ts[-1].start()
    for t in ts:
        t.join()
    if not is_outdated(target, rule[1]):
        return
    with __jobSemaphore:
        for c in rule[2]:
            c()
        for o in rule[0]:
            assert not is_outdated(o, rule[1])

def update_all():
    ts = []
    for t in __targets:
        ts.append(threading.Thread(target=update, args=[t]))
        ts[-1].start()
    for t in ts:
        t.join()

def library_config(cmdstr):
    import subprocess
    child = subprocess.Popen(cmdstr, shell=True, stdout=subprocess.PIPE)
    return child.communicate()[0].split()

def regex_glob(basepath, regex):
    import os, re
    from os import path
    reobj = re.compile(regex)
    for root, dirs, files in os.walk(basepath):
        for f in files:
            p = path.join(root, f)
            if reobj.search(p):
                yield p

def parse_make_rule(rule):
    import re
    retval = rule
    # concatenate lines
    retval = retval.replace("\\\n", "")
    # break into targets: depends
    targs, deps = retval.split(":", 1)
    # split allowing for whitespace escapes
    targs, deps = [ filter(None, re.split(r"(?<!\\)\s", x)) for x in [targs, deps] ]
    return targs, deps

def parse_source_dep_file(source, depfile):
    import errno
    try:
        targs, deps = parse_make_rule(open(depfile).read())
    except IOError as e:
        if e.errno in [errno.ENOENT]:
            return []
        else:
            raise
    #assert targs == source
    return deps

def clean():
    import os
    for t in __targets:
        os.unlink(t)

from glob import glob
import sys

objs = []
#regex_glob("src", "\.c[^.]*$"):
sources = glob("src/*.c") + glob("src/*.cc") + glob("src/*.cpp")
for s in sources:
    print s
    def msvc_source_depgen(args, output):
        def inner():
            child = subprocess.Popen(args, stdout=subprocess.PIPE)
            DEP_PREFIX = "Note: including file:"
            retval = []
            with open(output, "wb") as dfp:
                for line in child.stdout:
                    if line.startswith(DEP_PREFIX):
                        dfp.write(line[len(DEP_PREFIX):].lstrip())
            assert child.wait() == 0
        return inner
    o = s + ".d"
    if os.name != "nt":
        c = ["cpp", "-MM", "-MF", o, s]
    else:
        c = msvc_source_depgen(["cl", "/showIncludes", "/c", "/nologo", s, "/I" + "../../../gtest-trunk/include", "/I" + r"C:\Boost\include\boost-1_40", "/I" + r"C:\Python26\include"], o)
    add_rule([o], [s], [c])
    o = s + ".o"
    #c = ["g++", "-o", o, s, "-c"] + library_config("python-config --includes")
    #add_rule([o], parse_source_dep_file(s, s + ".d") or [s], [c])
    objs.append(o)
#add_rule(["benchmark"], objs, [["g++", "-o", "benchmark"] + objs + library_config("gtest-config --libs") + library_config("python-config --libs") + ["-lboost_system-mt"]])

if len(sys.argv) > 1 and sys.argv[1] == "clean":
    clean()
else:
    update_all()
