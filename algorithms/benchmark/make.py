#!/usr/bin/env python

import errno, os, threading, subprocess

__jobSemaphore = threading.BoundedSemaphore(4)
__targets = {}
class UpdateGuard(object):
    def __init__(self):
	self.__lock = threading.Lock()
	self.__updating = set()
	self.__updated = set()
	self.__condition = threading.Condition(self.__lock)
    def claim_update(self, outputs):
	with self.__lock:
	    #if len(outputs) > 1:
		#pdb.set_trace()
	    print "claim_update(", outputs, ")"
	    if set(outputs) <= (self.__updating | self.__updated):
		return False
	    else:
		assert self.__updating.isdisjoint(outputs)
		self.__updating.update(outputs)
		return True
    def updated(self, outputs):
	outputs = set(outputs)
	with self.__lock:
	    print "updated(", outputs, ")"
	    self.__updating -= outputs
	    self.__updated.update(outputs)
	    self.__condition.notify_all()
    def wait_updated(self, deps):
	#deps = set(deps) & __targets.keys()
	with self.__condition:
	    while not deps <= self.__updated:
		print "wait_updated(", deps, ")"
		self.__condition.wait()
__guard = UpdateGuard()

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
    def __init__(self, args):
        self.args = args
    def __call__(self):
        print subprocess.list2cmdline(self.args)
        subprocess.check_call(self.args)

def update(target):
    outputs, inputs, commands = __targets[target]
    if not __guard.claim_update(outputs):
	return
    ts = []
    for i in inputs:
        if i in __targets:
	    ts.append(threading.Thread(target=update, name=i, args=[i]))
	    ts[-1].start()
    for t in ts:
        t.join()
    if not is_outdated(target, inputs):
	__guard.updated([target])
        return
    __guard.wait_updated(set(inputs).intersection(__targets.keys()))
    with __jobSemaphore:
        for c in commands:
            c()
    for o in outputs:
	assert not is_outdated(o, inputs)
    __guard.updated(outputs)

def update_all():
    ts = []
    #print __targets.keys()
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

class ProjectType(type):
    def __init__(meta, name, bases, attrs):
	super(ProjectType, meta).__init__(name, bases, attrs)
	try:
	    newFields = attrs["__fields__"]
	    assert len(set(newFields)) == len(newFields)
	    assert meta._fields_.isdisjoint(newFields)
	    meta._fields_.update(newFields)
	except KeyError:
	    pass

class Project(object):
    __metaclass__ = ProjectType
    _fields_ = set()
    def __init__(self):
	for name in self._fields_:
	    assert not hasattr(self, name)
	    print name
	    setattr(self, name, None)	    
    def __setattr__(self, key, value):
	if not key in self._fields_:
	    raise AttributeError("Can't set %s" % key)
	else:
	    super(Project, self).__setattr__(key, value)
    #def build(self):
	#print "build"

class CProject(Project):
    __fields__ = [
	    "sources",
	    "compiler",
	    "includedirs",
	    "buildoptions",
	    "objects",
	    "targetdir",
	    "targetprefix",
	    "targetname",
	    "targetext",
	    "linkoptions"]
    def __init__(self, targetname):
	self.objects = []
	self.targetdir = "build"
	self.targetprefix = ""
	self.targetname = targetname
	self.targetext = ""
	self.linkoptions = []
    def build(self):
	try:
	    os.makedirs(self.targetdir)
	except OSError as e:
	    if e.errno not in [errno.EEXIST]:
		raise
	objs = self.objects
	for s in self.sources:
	    add_rule(*self.source_dep(s))
	    object, rule = self.object(s)
	    add_rule(*rule)
	    objs.append(object)
	targets, rule = self.targets(objs)
	add_rule(*rule)

class CxxProject(CProject):
    def __new__(cls, *args):
	if cls != CxxProject:
	    return super(CxxProject, cls).__new__(cls)
	if os.name != "nt":
	    return GxxProject.__new__(GxxProject, *args)

class GxxProject(CxxProject):
    def __init__(self, targetname):
	super(GxxProject, self).__init__(targetname)
	self.compiler = "g++"
    def source_dep(self, source):
	o = source + ".d"
	return [o], [source], [ShellCommand(["cpp", "-MM", "-MF", o, source])]
    def object(self, source):
	inputs = parse_source_dep_file(source, source + ".d") or [source]
	object = source + ".o"
	return object, ([object], inputs, [ShellCommand(["g++", "-o", object, source, "-c"] + self.buildoptions)])
    def targets(self, objects):
	target = os.path.join(self.targetdir, self.targetprefix + self.targetname + self.targetext)
	return target, ([target], objects, [ShellCommand(["g++", "-o", target] + objects + self.linkoptions)])
    
from glob import glob
import sys

benchmark = CxxProject("benchmark")
benchmark.sources = regex_glob("src", "\.c[^.]*$")
benchmark.buildoptions = library_config("python-config --includes")
benchmark.linkoptions = library_config("gtest-config --libs") + library_config("python-config --libs") + ["-lboost_system-mt"]
benchmark.build()

#objs = []
##regex_glob("src", "\.c[^.]*$"):
#sources = glob("src/*.c") + glob("src/*.cc") + glob("src/*.cpp")
#for s in sources:
    #print s
    #def msvc_source_depgen(args, output):
        #def inner():
            #child = subprocess.Popen(args, stdout=subprocess.PIPE)
            #DEP_PREFIX = "Note: including file:"
            #retval = []
            #with open(output, "wb") as dfp:
                #for line in child.stdout:
                    #if line.startswith(DEP_PREFIX):
                        #dfp.write(line[len(DEP_PREFIX):].lstrip())
            #assert child.wait() == 0
        #return inner
    #o = s + ".d"
    #if os.name != "nt":
        #c = ["cpp", "-MM", "-MF", o, s]
    #else:
        #c = msvc_source_depgen(["cl", "/showIncludes", "/c", "/nologo", s, "/I" + "../../../gtest-trunk/include", "/I" + r"C:\Boost\include\boost-1_40", "/I" + r"C:\Python26\include"], o)
    #add_rule([o], [s], [c])
    #o = s + ".o"
    ##c = ["g++", "-o", o, s, "-c"] + library_config("python-config --includes")
    ##add_rule([o], parse_source_dep_file(s, s + ".d") or [s], [c])
    #objs.append(o)
##add_rule(["benchmark"], objs, [["g++", "-o", "benchmark"] + objs + library_config("gtest-config --libs") + library_config("python-config --libs") + ["-lboost_system-mt"]])

if len(sys.argv) > 1 and sys.argv[1] == "clean":
    clean()
else:
    update_all()
