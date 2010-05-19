#!/usr/bin/env python

import contextlib, os, signal, struct, subprocess

def find_client_pid():
	child = subprocess.Popen(["pgrep", "Tibia"], stdout=subprocess.PIPE)
	return int(child.communicate()[0])

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
	child = subprocess.Popen(["./readmem", str(pid), hex(address), str(size)], stdout=subprocess.PIPE)
	data = child.communicate()[0]
	assert child.returncode == 0
	return data

ENTITY_ARRAY_OFFSET = 0x8570740
ENTITY_STRUCT_SIZE = 0xa8
PLAYER_CURRENT_MANA = 0x0857ad08
PLAYER_ENTITY_ID = 0x0857ac54
PLAYER_AMMO_SLOT = 0x856deac
LOGIN_LIST_INDEX = 0x8427d8c
#0xBFE25ED4

class Entity(object):
	_memfmt = struct.Struct("I32s33I")
	def __init__(self, stbuf):
		fields = self._memfmt.unpack(stbuf)
		self.id = fields[0]
		self.name = fields[1]
		self.onscreen = fields[29]
		self.unknown = fields[2:29] + fields[30:]
	def __str__(self):
		return "Entity (id: {0:08x}, name: {1}, onscreen: {2}, unknown: {3})".format(
				self.id, self.name, self.onscreen, self.unknown)

class Client(object):
	def __init__(self, pid=None):
		if pid is None:
			pid = find_client_pid()
		self.pid = pid
		self.attached = False
	def iter_memory_regions(self):
		for region in iter_proc_maps(self.pid):
			if region.inode == 0:
				data = self.read_memory(region.start, region.length)
				yield region.start, data
	def read_memory(self, address, size):
		return read_process_memory(self.pid, address, size)
	def find_string(self, s):
		for offset, data in self.iter_memory_regions():
			pos = -1
			while True:
				pos = data.find(s, pos + 1)
				if pos < 0:
					break
				yield pos + offset
	def iter_entities(self):
		offset = ENTITY_ARRAY_OFFSET
		while True:
			data = self.read_memory(offset, ENTITY_STRUCT_SIZE)
			offset += ENTITY_STRUCT_SIZE
			entity = Entity(data)
			if entity.name[0] == "\0":
				break
			else:
				yield entity

if __name__ == "__main__":
	a = Client()
	a.find_string("Eruanna Darkelf")
	for b in a.iter_entities():
		print b
	a.dump_memory()
