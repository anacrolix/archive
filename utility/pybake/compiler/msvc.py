from pybake.classes import Command, SystemTask

OBJ_SUFFIX = ".obj"
EXE_SUFFIX = ".exe"

def define(macro):
    return ["/D", macro]

def include(*incpath):
    return reduce(lambda x, y: x + y, [("/I", i) for i in incpath])

def libpath(libpath):
    return ["/LIBPATH:" + libpath]

def library(*names):
    return [a + ".lib" for a in names]

class Compiler(Command):
    def __init__(self, cflags=None):
        self.cflags = cflags or []
    def __call__(self, outputs, inputs):
        assert len(outputs) == 1
        assert len(inputs) == 1
        args = ["cl", "/c", "/EHsc", "/MD", "/nologo"]
        args += ["/Fo" + outputs[0]]
        args += inputs
        args += self.cflags
        SystemTask(args)()
        return True

class Linker(Command):
    def __init__(self, ldflags=None):
        self.ldflags = ldflags or []
    def __call__(self, outputs, inputs):
        assert len(outputs) == 1
        args = ["link", "/SUBSYSTEM:CONSOLE", "/NOLOGO"]
        args += ["/OUT:" + outputs[0]]
        args += inputs
        args += self.ldflags
        SystemTask(args)()
        return True
