from pybake.classes import Command, SystemTask

class Compiler(Command):
	def __init__(self, defines=None, includes=None):
		self.defines = defines
		self.includes = includes
	def __call__(self, outputs, inputs):
		assert len(outputs) == 1
		assert len(inputs) == 1
		args = ["cl", "/c", "/EHsc", "/MD", "/nologo"]
		args += ["/Fo" + outputs[0]]
		args += inputs
		args += reduce(lambda y, z: y + z, [("/D", x) for x in self.defines])
		args += [("/I", x) for x in self.includes]
		SystemTask(args)()
		return True
		
class Linker(Command):
	def __init__(self, libpaths=[]):
		self.libpaths = libpaths
	def __call__(self, outputs, inputs):
		assert len(outputs) == 1
		args = ["link", "/SUBSYSTEM:CONSOLE", "/NOLOGO"]
		args += ["/OUT:" + outputs[0]]
		args += ["/LIBPATH:" + x for x in self.libpaths]
		args += inputs
		SystemTask(args)()
		return True
		
		
	