
class MemoryReadError(Exception):
	pass

#("address", "perms", "offset", "dev", "inode", "pathname"),
class ProcMapsLine(object):
	def __init__(self, line):
		self.__line = line.rstrip("\n")
		fields = self.__line.split(None, 5)
		assert len(fields) in xrange(5, 7), self.line
		self.inode = int(fields[4])
		self.start, self.end = map(lambda x: int(x, 16), fields[0].split("-"))
		self.length = self.end - self.start
		self.address = fields[0]
	def __repr__(self):
		return self.__line

def iter_proc_maps(pid):
	with open("/proc/{0}/maps".format(pid)) as mapsfile:
		for line in mapsfile:
			yield ProcMapsLine(line)

def read_process_memory(pid, address, size):
	"""Read memory region by calling external C utility"""
	from subprocess import Popen, PIPE
	for attempt in xrange(5):
		child = Popen(
				["./readmem", str(pid), hex(address), str(size)],
				stdout=PIPE)
		data = child.communicate()[0]
		#assert child.poll()
		if child.returncode == 0:
			#print "succeed"
			return data
		elif child.returncode == 3:
			time.sleep(0)
			continue
		else:
			break
	raise MemoryReadError()

def read_process_memory(pid, address, size):
	"""Read memory region by using ptrace module"""
	from errno import ESRCH
	from ptrace import wait_for_tracee_stop, ptrace_attach, ptrace_detach
	ptrace_attach(pid)
	try:
		wait_for_tracee_stop(pid)
		with open("/proc/{0}/mem".format(pid)) as memfile:
			# Python must be using pread or some other clever caching
			# as it doesn't generate errors due to IO unaligned to pages
			memfile.seek(address)
			return memfile.read(size)
	finally:
		# try not to mask exceptions thrown in the try block
		try:
			ptrace_detach(pid)
		except OSError as e:
			# ESRCH given if we're not attached, which is what we want
			if e.errno != ESRCH:
				raise
