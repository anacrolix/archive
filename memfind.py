import ptrace, os
from struct import *

class TraceApp:
    def __init__(self, pid):
	self.pid = pid
    def attach(self):
#         try:
        ptrace.attach(self.pid)
        os.waitpid(self.pid, 0)
	self.mem = os.open("/proc/%d/mem" % (self.pid), os.O_RDWR)
    def detach(self):
	os.close(self.mem)
	ptrace.detach(self.pid, 0)
    def findall(self, start, end, fmt, val, last=None):
	self.attach()
	os.lseek(self.mem, start, 0)
	buf = os.read(self.mem, end-start)
	step = calcsize(fmt)
	matches = []
	if (last == None): last = range(start, end, step)
	for off in last:
	    if (unpack(fmt, buf[off-start:off-start+step])[0] == val):
		matches.append(off)
	self.detach()
	return matches
    def poke(self, addr, data):
	self.attach()
	ptrace.pokedata(self.pid, addr, data)
	self.detach()
#def findval
#086882D8
