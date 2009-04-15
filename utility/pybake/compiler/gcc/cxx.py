from pybake.classes import Command, SystemTask
import re

OBJ_SUFFIX = ".o"
EXE_SUFFIX = ""

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

