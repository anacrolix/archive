import errno
import os
import subprocess
import sys
from os import path
from core import pb_print, PybakeStop
from constant import *
import util

class Command(object):
    pass

class ShellCommand(Command):
    def __init__(self, args):
        self.args = args
    def __call__(self):
	cmdline = subprocess.list2cmdline(self.args)
	pb_print(cmdline, color="cyan")
	try:
	    child = subprocess.Popen(self.args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	except OSError as e:
	    if e.errno != errno.ENOENT:
		raise
	    raise PybakeStop("A necessary file was not found")
	self.process_streams(*child.communicate())
	if child.returncode != 0:
	    raise PybakeStop("Command returned %d: %s" % (child.returncode, repr(cmdline)))
    def process_streams(self, outdata, errdata):
	if errdata: pb_print(errdata, color="red")
	if outdata: pb_print(outdata, color="yellow")

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
    def __init__(self, name, recipe):
	super(Project, self).__init__()
	#for name in self._fields_:
	    #assert not hasattr(self, name)
	    #print name
	    #setattr(self, name, None)
	self.name = name
	recipe.add_project(self)
    def __setattr__(self, key, value):
	if not key in self._fields_:
	    raise AttributeError("Can't set %s" % key)
	else:
	    super(Project, self).__setattr__(key, value)

class CProject(Project):
    __fields__ = [
	    "builddir",
	    "buildoptions",
	    "debug",
	    "sources",
	    "compiler",
	    "linkoptions",
	    "links",
	    "libdirs",
	    "includedirs",
	    "objects",
	    "optimize",
	    "targetdir",
	    "targetprefix",
	    "targetname",
	    "targetext",
	]
    def __init__(self, targetname, recipe):
	super(CProject, self).__init__(targetname, recipe)
	self.builddir = path.join(".pybake2", sys.platform, recipe.get_config())
	self.debug = False
	self.includedirs = []
	self.libdirs = []
	self.links = []
	self.objects = []
	self.optimize = False
	self.targetdir = ""
	self.targetprefix = ""
	self.targetname = targetname
	#self.targetext = ""
	self.linkoptions = []
    def generate_rules(self):
	retRules = []
	objects = self.objects
	for srcpath in self.sources:
	    objpath, rules = self.compile(srcpath)
	    retRules += rules
	    objects.append(objpath)
	targets, rule = self.targets(objects)
	retRules.append(rule)
	return targets, retRules

class CxxProject(CProject):
    def __new__(cls, *args):
	if cls != CxxProject:
	    return super(CxxProject, cls).__new__(cls)
	if os.name == "nt":
	    return MsvcProject.__new__(MsvcProject, *args)
	else:
	    return GxxProject.__new__(GxxProject, *args)

class GenerateMsvcSourceDeps(Command):
    def __init__(self, cmdargs, outpath, srcpath):
	self.cmdargs = cmdargs
	self.outpath = outpath
	self.srcpath = srcpath
    def __call__(self):
	pb_print(subprocess.list2cmdline(self.cmdargs), color=CMDLINE)
	child = subprocess.Popen(self.cmdargs, stdout=subprocess.PIPE)
	DEP_PREFIX = "Note: including file:"
	hdrdeps = set([])
	for line in child.stdout:
	    if line.startswith(DEP_PREFIX):
		hdrdeps.add(line[len(DEP_PREFIX):].strip())
	    elif line.rstrip() != path.basename(self.srcpath):
		pb_print(line, color=WARNING)
	assert child.wait() == 0
	open(self.outpath, "w").write(repr(hdrdeps))

def parse_source_dep_file(depFilePath):
    try:
	return list(eval(open(depFilePath).read()))
    except IOError as e:
	if e.errno not in [errno.ENOENT]:
	    raise
    #except SyntaxError:
	#pass
    return []

class MsvcProject(CxxProject):
    def __init__(self, targetname, recipe):
	super(self.__class__, self).__init__(targetname, recipe)
	self.targetext = ".exe"
    def source_dep(self, srcpath, hdeppath):
	return [hdeppath], [srcpath],
    def compile(self, srcpath):
	hdeppath = path.join(self.builddir, srcpath + ".d")
	objpath = path.join(self.builddir, srcpath + ".obj")
	hdeprule = (
		[hdeppath],
		[srcpath],
		[GenerateMsvcSourceDeps(
			["cl", srcpath, "/showIncludes", "/c", "/nologo", "/EHsc"] + ["/I" + id for id in self.includedirs],
			hdeppath,
			srcpath)])
	args = ["cl", "/Fo" + objpath, srcpath, "/c", "/nologo", "/EHsc", "/MD"] + ["/I" + id for id in self.includedirs]
	if self.debug:
	    args.append("/Zi")
	if self.optimize:
	    args.append("/O2")
	inputs = parse_source_dep_file(hdeppath) + [srcpath]
	objrule = [objpath], inputs, [ShellCommand(args)]
	return objpath, [hdeprule, objrule]
    def targets(self, objects):
	target = os.path.join(self.targetdir, self.targetprefix + self.targetname + self.targetext)
	#print objects
	return target, ([target], objects, [ShellCommand(["link", "/OUT:" + target] + objects + ["/LIBPATH:" + lp for lp in self.libdirs] + self.links + ["/NOLOGO"])])

class GenerateGccSourceDeps(Command):
    def __init__(self, cmdargs, outpath, srcpath, dummyTarget):
	self.cmdargs = cmdargs
	self.outpath = outpath
	self.srcpath = srcpath
	self.dummyTarget = dummyTarget
    def __call__(self):
	pb_print(subprocess.list2cmdline(self.cmdargs), color=CMDLINE)
	child = subprocess.Popen(self.cmdargs, stdout=subprocess.PIPE)
	targs, deps = util.parse_make_rule(child.communicate()[0])
	assert child.returncode == 0
	assert len(targs) == 1
	assert targs[0] == self.dummyTarget
	open(self.outpath, "w").write(repr(set(deps)))

class GxxProject(CxxProject):
    def __init__(self, targetname, recipe):
	super(GxxProject, self).__init__(targetname, recipe)
	#self.compiler = "g++"
	self.targetext = ""
    def compile(self, srcpath):
	hdeppath = path.join(self.builddir, srcpath + ".d")
	objpath = path.join(self.builddir, srcpath + ".o")
	hdeprule = (
		[hdeppath],
		[srcpath],
		[GenerateGccSourceDeps(["cpp", "-MM", "-MT", "gayness", srcpath], hdeppath, srcpath, "gayness")])
	args = ["g++", "-c", "-pipe"]
	args += ["-o", objpath, srcpath]
	args += self.buildoptions
	if self.debug:
	    args += ["-g"]
	if self.optimize:
	    args += ["-O2"]
	# the source dep INCLUDES the source file itself for GCC
	inputs = parse_source_dep_file(hdeppath) or [srcpath]
	assert srcpath in inputs
	objrule = [objpath], inputs, [ShellCommand(args)]
	return objpath, [hdeprule, objrule]
    def targets(self, objects):
	target = os.path.join(self.targetdir, self.targetprefix + self.targetname + self.targetext)
	return [target], ([target], objects, [ShellCommand(["g++", "-o", target] + objects + ["-pipe"] + self.linkoptions)])
