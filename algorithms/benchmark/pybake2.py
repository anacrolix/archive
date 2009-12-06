#!/usr/bin/env python

import errno, os, pdb, threading, subprocess, sys

class FatalThread(threading.Thread):
    def __init__(self, *args, **kwargs):
	threading.Thread.__init__(self, *args, **kwargs)
	self.unhandled = False
    def run(self):
	try:
	    threading.Thread.run(self)
	except:
	    self.unhandled = True
	    raise

class ThreadPool(object):
    def __init__(self):
	object.__init__(self)
	self.__threads = []
    def add_thread(self, *args, **kwargs):
	self.__threads.append(FatalThread(*args, **kwargs))
	self.__threads[-1].start()
    def join_all(self):
	for t in self.__threads:
	    if t.unhandled:
		sys.exit("wees & poos")

#class FatalThread(threading.Thread):
    #def run(self):
	#try:
	    #super(self.__class__, self).run()
	#except:
	    #sys.excepthook(*sys.exc_info())
	    #sys.exit()

#threading.Thread = FatalThread

__jobSemaphore = threading.BoundedSemaphore(4)
__targets = {}
__phonies = {}
_printLock = threading.Lock()
class UpdateGuard(object):
    def __init__(self):
	self.__lock = threading.Lock()
	self.__updating = set()
	self.__updated = set()
	self.__condition = threading.Condition(self.__lock)
    def claim_update(self, outputs):
	with self.__lock:
	    if outputs <= self.__updating | self.__updated:
		return False
	    else:
		assert self.__updating.isdisjoint(outputs)
		self.__updating.update(outputs)
		return True
    def updated(self, outputs):
	with self.__lock:
	    assert outputs <= self.__updating
	    self.__updating -= outputs
	    self.__updated |= outputs
	    self.__condition.notify_all()
    def wait_updated(self, deps):
	with self.__condition:
	    while not deps <= self.__updated:
		self.__condition.wait()
__guard = UpdateGuard()

class PybakeError(Exception):
    pass

def add_rule(outputs, inputs, commands):
    rule = (set(outputs), set(inputs), commands)
    for index, seq in enumerate([outputs, inputs, commands]):
	assert len(rule[index]) == len(seq)
    for o in outputs:
        assert not o in __targets
        __targets[o] = (set(outputs), set(inputs), commands)

def is_outdated(target, deps):
    #print "is_outdated(", target, deps, ")"
    try:
        targetMtime = os.stat(target).st_mtime
    except OSError as e:
        if e.errno == errno.ENOENT:
            return True
        else:
            raise
    for d in deps | set([sys.argv[0]]):
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
	with _printLock:
	    print subprocess.list2cmdline(self.args)
        subprocess.check_call(self.args)

def update(target):
    outputs, inputs, commands = __targets[target]
    if not __guard.claim_update(outputs):
	return
    tp = ThreadPool()
    for i in inputs:
        if i in __targets:
	    tp.add_thread(target=update, name=i, args=[i])
	    #ts.append(threading.Thread(target=update, name=i, args=[i]))
	    #ts[-1].start()
    #for t in ts:
    #    t.join()
    tp.join_all()
    __guard.wait_updated(set(inputs).intersection(__targets.keys()))
    if not is_outdated(target, inputs):
	__guard.updated(set([target]))
        return
    with __jobSemaphore:
        for c in commands:
            c()
    for o in outputs:
	assert not is_outdated(o, inputs)
    __guard.updated(outputs)

def update_all():
    tp = ThreadPool()
    for t in __targets:
	tp.add_thread(target=update, args=[t])
    tp.join_all()

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
    #pdb.set_trace()
    return targs, deps

def clean():
    import os
    rmCount = 0
    for t in __targets:
	try:
	    os.unlink(t)
	except OSError as e:
	    if e.errno not in [errno.ENOENT]:
		raise
	else:
	    print "unlinked", t
	    rmCount += 1
    print rmCount, "files removed"

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
    _fields_ = set([
	"name",])
    def __init__(self, name):
	super(Project, self).__init__()
	#for name in self._fields_:
	    #assert not hasattr(self, name)
	    #print name
	    #setattr(self, name, None)
	self.name = name
	add_project(self)
    def __setattr__(self, key, value):
	if not key in self._fields_:
	    raise AttributeError("Can't set %s" % key)
	else:
	    super(Project, self).__setattr__(key, value)
	#def build(self):
	#print "build"

class CProject(Project):
    __fields__ = [
	"debug",
        "sources",
        "compiler",
        "includedirs",
        "buildoptions",
        "objects",
        "targetdir",
        "targetprefix",
        "targetname",
        "targetext",
        "linkoptions",
	"links",
	"libdirs",]
    def __init__(self, targetname):
	super(CProject, self).__init__(targetname)
	self.debug = False
	self.objects = []
	self.targetdir = "build"
	self.targetprefix = ""
	self.targetname = targetname
	#self.targetext = ""
	self.linkoptions = []
    def generate_rules(self):
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
	return targets

class CxxProject(CProject):
    def __new__(cls, *args):
	if cls != CxxProject:
	    return super(CxxProject, cls).__new__(cls)
	if os.name == "nt":
	    return MsvcProject.__new__(MsvcProject, *args)
	else:
	    return GxxProject.__new__(GxxProject, *args)
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
        #c = msvc_source_depgen(["cl", "/showIncludes", "/c", "/nologo", s, "/I" + "../../../gtest-trunk/include", "/I" + r"C:\Boost\include\boost-1_40", "/I" + r"C:\Python26\include"], o)
class GenerateMsvcSourceDeps(Command):
    def __init__(self, cmdargs, outpath):
	self.cmdargs = cmdargs
	self.outpath = outpath
    def __call__(self):
	with _printLock:
	    print subprocess.list2cmdline(self.cmdargs)
	child = subprocess.Popen(self.cmdargs, stdout=subprocess.PIPE)
	DEP_PREFIX = "Note: including file:"
	hdrdeps = set([])
	for line in child.stdout:
	    if line.startswith(DEP_PREFIX):
		hdrdeps.add(line[len(DEP_PREFIX):].strip())
	open(self.outpath, "w").write(repr(hdrdeps))
	assert child.wait() == 0

def parse_source_dep_file(depFilePath):
    try:
	return list(eval(open(depFilePath).read()))
    except IOError as e:
	if e.errno not in [errno.ENOENT]:
	    raise
    except SyntaxError:
	pass
    return []

class MsvcProject(CxxProject):
    def __init__(self, targetname):
	super(self.__class__, self).__init__(targetname)
	self.targetext = ".exe"
    def source_dep(self, source):
	o = source + ".d"
	return [o], [source], [GenerateMsvcSourceDeps(["cl", source, "/showIncludes", "/c", "/nologo"] + ["/I" + id for id in self.includedirs], o)]
    def object(self, source):
	inputs = parse_source_dep_file(source + ".d") + [source]
	object = source + ".o"
	args = ["cl", "/Fo" + object, source, "/c", "/nologo", "/EHsc", "/MD"] + ["/I" + id for id in self.includedirs]
	if self.debug:
	    raise PybakeError("Debug not supported for MSVC")
	return object, ([object], inputs, [ShellCommand(args)])
    def targets(self, objects):
	target = os.path.join(self.targetdir, self.targetprefix + self.targetname + self.targetext)
	#print objects
	return target, ([target], objects, [ShellCommand(["link", "/OUT:" + target] + objects + ["/LIBPATH:" + lp for lp in self.libdirs] + self.links + ["/NOLOGO"])])

class GenerateMakeSourceDeps(Command):
    def __init__(self, cmdargs, outpath, target):
	self.cmdargs = cmdargs
	self.outpath = outpath
	self.target = target
    def __call__(self):
	with _printLock:
	    print subprocess.list2cmdline(self.cmdargs)
	child = subprocess.Popen(self.cmdargs, stdout=subprocess.PIPE)
	targ, deps = parse_make_rule(child.communicate()[0])
	assert targ == [self.target]
	open(self.outpath, "w").write(repr(set(deps)))
	assert child.wait() == 0

class GxxProject(CxxProject):
    def __init__(self, targetname):
	super(GxxProject, self).__init__(targetname)
	#self.compiler = "g++"
	self.targetext = ""
    def source_dep(self, source):
	o = source + ".d"
	return [o], [source], [GenerateMakeSourceDeps(["cpp", "-MM", "-MT", "gayness", source], o, "gayness")]
    def object(self, source):
	inputs = parse_source_dep_file(source + ".d") or [source]
	object = source + ".o"
	args = ["g++", "-c", "-pipe"]
	args += ["-o", object, source]
	args += self.buildoptions
	if self.debug:
	    args += ["-g"]
	return object, ([object], inputs + [source + ".d"], [ShellCommand(args)])
    def targets(self, objects):
	target = os.path.join(self.targetdir, self.targetprefix + self.targetname + self.targetext)
	return [target], ([target], objects, [ShellCommand(["g++", "-o", target] + objects + ["-pipe"] + self.linkoptions)])

__projects = set()

def add_project(project):
    assert not project in __projects
    __projects.add(project)

def set_configurations(*confs):
    global __configurations
    __configurations = tuple(confs)

def is_configuration(conf):
    assert conf in __configurations
    return CONFIGURATION == conf

from optparse import OptionParser
parser = OptionParser()
parser.set_defaults(file="bake")
parser.add_option("--config")
parser.add_option("--file")
opts, args = parser.parse_args()

CONFIGURATION = opts.config
execfile(opts.file, globals(), {})

print CONFIGURATION
for p in __projects:
    assert not p.name in __phonies
    __phonies[p.name] = p.generate_rules()

if len(args) == 0:
    update_all()
else:
    if "clean" in args:
	args.remove("clean")
	clean()
    for a in args:
	for t in __phonies[a]:
	    update(t)
