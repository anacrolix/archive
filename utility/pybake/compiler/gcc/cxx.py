from pybake.classes import Command, SystemTask, ExplicitRule
import re

def libflag(libname):
    return ["-l" + libname]

def incflag(incpath):
    return ["-I" + incpath]

class Compiler(Command):
    def __init__(self, cflags=None):
        self.cflags = cflags or []
    def __call__(self, outputs, inputs):
        assert len(outputs) == 1
        assert len(inputs) == 1
        args = ["gcc", "-c"]
        args += ["-o", outputs[0]]
        args += inputs
        args += self.cflags
        SystemTask(args)()
        return True

class Linker(Command):
    def __init__(self, ldflags=None):
        self.ldflags = ldflags or []
    def __call__(self, outputs, inputs):
        assert len(outputs) == 1
        args = ["gcc"]
        args += ["-o", outputs[0]]
        args += inputs
        args += self.ldflags
        SystemTask(args)()
        return True

OBJ_SUFFIX = ".o"
EXE_SUFFIX = ""

def object_file(source, cflags):
    obj = re.sub(r"\..*?$", OBJ_SUFFIX, source)
    ExplicitRule([obj], [source], Compiler(cflags))
    return obj

def executable(exename, sources, cflags=None, ldflags=None):
    objs = []
    for src in sources:
        objs.append(object_file(src, cflags))
    ExplicitRule([exename + EXE_SUFFIX], objs, Linker(ldflags))
