#!/usr/bin/env python

import contextlib, operator, os, signal, struct, subprocess

class ClientNotFound(Exception):
	pass

def find_client_pid():
	child = subprocess.Popen(["pgrep", "Tibia"], stdout=subprocess.PIPE)
	stdout = child.communicate()[0]
	if len(stdout) == 0:
		raise ClientNotFound()
	return int(stdout)

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
	assert child.returncode == 0, "Memory read failed"
	return data

class EntityId(int):
	def __new__(cls, buf):
		#print cls, repr(buf)
		return int.__new__(cls, struct.unpack("I", buf)[0])
	def is_player(self):
		return self < 0x40000000
	def __str__(self):
		return "{0:08x}".format(self)

ENTITY_ARRAY_OFFSET = 0x8570740
ENTITY_STRUCT_SIZE = 0xa8
PLAYER_TARGET_ID = 0x0857ad1c
PLAYER_CURRENT_HITPOINTS = 0x0857ac58
PLAYER_MAXIMUM_HITPOINTS = 0x0857ac5c
PLAYER_CURRENT_MANA = 0x0857ad08
PLAYER_MAXIMUM_MANA = 0x0857ad0c
PLAYER_ENTITY_ID = 0x0857ac54
PLAYER_AMMO_SLOT = 0x856deac
PLAYER_COORDS = 0x0842d740
LOGIN_LIST_INDEX = 0x8427d8c
#0xBFE25ED4

class EntityCoords(tuple):
	def __sub__(self, other):
		return EntityCoords(map(operator.sub, self, other))
	def as_relative(self):
		retval = []
		z = self[2]
		if z:
			retval.append("{0} {1} levels".format("up" if z < 0 else "down", abs(z)))
		dirstr = ""
		y = self[1]
		if y:
			dirstr += "north" if y < 0 else "south"
		x = self[0]
		if x:
			dirstr += "west" if x < 0 else "east"
		if dirstr:
			retval.append(dirstr)
		return ", ".join(retval)

def strncpy(buf, n=None):
	if n == None:
		n = len(buf)
	nullpos = buf.find("\0", 0, n)
	assert nullpos < n
	return buf[:(n if nullpos == -1 else nullpos)]

class Entity(object):
	_memfmt = struct.Struct("4s32s33i")
	def __init__(self, stbuf):
		fields = self._memfmt.unpack(stbuf)
		self.id = EntityId(fields[0])
		self.name = strncpy(fields[1])
		self.coords = EntityCoords(fields[2:5])
		self.speed = fields[28]
		self.onscreen = fields[29]
		self.unknown = fields[5:28] + fields[30:]
	def speed_as_level(self):
		#assert not self.speed & 1, str(self)
		return (self.speed - 218) / 2
	def is_player(self):
		return self.id.is_player()
	def human_readable(self, reltopos=None):
		if reltopos is not None:
			position = (self.coords-reltopos).as_relative()
		else:
			position = self.coords
		return "{name}; level: ~{level}; position: {position}".format(
				name=self.name,
				level=self.speed_as_level(),
				position=position)
	def __str__(self):
		return "Entity (id: {0}, name: {1}, onscreen: {2}, coords: {3}, speed {4} (level {5}), unknown: {6})".format(
				self.id, self.name, self.onscreen, self.coords, self.speed, self.speed_as_level(), self.unknown)
	def __nonzero__(self):
		return self.id != 0 and len(self.name) > 0

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
	def read_structured_memory(self, address, strctfmt):
		strctobj = struct.Struct(strctfmt)
		return strctobj.unpack(self.read_memory(address, strctobj.size))
	def read_memory(self, address, size):
		return read_process_memory(self.pid, address, size)
	def player_coords(self):
		return EntityCoords(self.read_struct_from_memory(PLAYER_COORDS, struct.Struct("iii")))
	def find_string(self, s):
		for offset, data in self.iter_memory_regions():
			pos = -1
			while True:
				pos = data.find(s, pos + 1)
				if pos < 0:
					break
				yield pos + offset
	def human_readable_entity(self, entity):
		assert entity.onscreen
		return "{name}; level: ~{level}; position: {relpos}".format(name=entity.name, level=entity.speed_as_level(), relpos=(entity.coords-client.player_coords()).as_relative())
	def player_target_entity_id(self):
		return EntityId(self.read_memory(PLAYER_TARGET_ID, 4))
	def player_entity_id(self):
		return EntityId(self.read_memory(PLAYER_ENTITY_ID, 4))
	def player_current_hitpoints(self):
		return struct.unpack("I", self.read_memory(PLAYER_CURRENT_HITPOINTS, 4))[0]
	def player_maximum_hitpoints(self):
		return struct.unpack("I", self.read_memory(PLAYER_MAXIMUM_HITPOINTS, 4))[0]
	def player_current_mana(self):
		return self.read_structured_memory(PLAYER_CURRENT_MANA, "i")[0]
	def player_maximum_mana(self):
		return self.read_structured_memory(PLAYER_MAXIMUM_MANA, "i")[0]
	def iter_entities(self):
		offset = ENTITY_ARRAY_OFFSET
		while True:
			data = self.read_memory(offset, ENTITY_STRUCT_SIZE)
			offset += ENTITY_STRUCT_SIZE
			entity = Entity(data)
			if not entity:
				break
			else:
				yield entity

if __name__ == "__main__":
	a = Client()
	a.find_string("Eruanna Darkelf")
	for b in a.iter_entities():
		print b
	a.dump_memory()
