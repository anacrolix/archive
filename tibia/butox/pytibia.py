#!/usr/bin/env python

import contextlib, itertools, operator, os, signal, struct, \
		subprocess, time

import botutil
from defcon.level import *

# CONSTANTS

ENTITY_ARRAY_OFFSET = 0x8570740
ENTITY_STRUCT_SIZE = 0xa8

# least common multiple of page and entity sizes
PAGE_ENTITY_LCD = 86016
assert (PAGE_ENTITY_LCD % ENTITY_STRUCT_SIZE) == 0
assert (PAGE_ENTITY_LCD % 4096) == 0

PLAYER_TARGET_ID = 0x0857ad1c
PLAYER_CURRENT_HITPOINTS = 0x0857ac58
PLAYER_MAXIMUM_HITPOINTS = 0x0857ac5c
PLAYER_CURRENT_MANA = 0x0857ad08
PLAYER_MAXIMUM_MANA = 0x0857ad0c
PLAYER_ENTITY_ID = 0x0857ac54
PLAYER_AMMO_SLOT = 0x856deac
PLAYER_COORDS = 0x0842d740
LOGIN_LIST_INDEX = 0x8427d8c
IDLE_TIMEOUT_SECS = 15 * 60

# PLAYER_*_PROGRESS addresses
SKILL_NAMES = ("fist", "club", "sword", "axe", "distance", "shielding", "fishing")
SKILL_PROGRESS_BASE_ADDRESS = 0x0857ad44
for skillnam, address in zip(
		SKILL_NAMES,
		itertools.imap(lambda x: 0x0857ad44 + x * 4, itertools.count())):
	varname = "PLAYER_" + skillnam.upper() + "_PROGRESS"
	assert not varname in globals()
	globals()[varname] = address
assert PLAYER_SWORD_PROGRESS == SKILL_PROGRESS_BASE_ADDRESS + 4 * SKILL_NAMES.index("sword")

# EXCEPTIONS

class ClientNotFound(Exception):
	pass

class MemoryReadError(Exception):
	pass

# GENERAL FUNCTIONS

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
	"""Read memory region by calling external C utility"""
	for attempt in xrange(5):
		child = subprocess.Popen(
				["./readmem", str(pid), hex(address), str(size)],
				stdout=subprocess.PIPE)
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
	import errno, traceback
	import ptrace
	ptrace.ptrace_attach(pid)
	try:
		#raise Exception("wtf")
		ptrace.wait_for_tracee_stop(pid)
		with open("/proc/{0}/mem".format(pid)) as memfile:
			memfile.seek(address)
			return memfile.read(size)
	finally:
		try:
			ptrace.ptrace_detach(pid)
		except OSError as e:
			if e.errno != errno.ESRCH:
				raise

class EntityId(int):
	def __new__(cls, buf):
		#print cls, repr(buf)
		return int.__new__(cls, struct.unpack("I", buf)[0])
	def is_player(self):
		return self < 0x40000000
	def __str__(self):
		return "{0:08x}".format(self)

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
		self.windowid = botutil.get_window_id("Tibia Player Linux")
		assert self.windowid != 0

	def terminate(self):
		self.notify(CRITICAL, "Closing client")
		os.kill(self.pid, signal.SIGKILL)

	def send_key_press(self, keystr):
		self.notify(INFO, "Sending key press: %s", keystr, name=self.player_entity().name)
		args = [botutil.cutil_path("xsendkey"), "-window", hex(self.windowid), keystr]
		subprocess.check_call(args)

	def notify(self, *pargs, **kwargs):
		kwargs.setdefault("name", self.player_entity().name)
		return botutil._notify(*pargs, **kwargs)

	# memory ops

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
	def find_string(self, s):
		for offset, data in self.iter_memory_regions():
			pos = -1
			while True:
				pos = data.find(s, pos + 1)
				if pos < 0:
					break
				yield pos + offset

	# pretty ops

	def human_readable_entity(self, entity):
		assert entity.onscreen
		return "{name}; level: ~{level}; position: {relpos}".format(name=entity.name, level=entity.speed_as_level(), relpos=(entity.coords-client.player_coords()).as_relative())

	# status ops

	def skill_progress(self, skillnam):
		progress = self.read_structured_memory(
				globals()["PLAYER_" + skillnam.upper() + "_PROGRESS"],
				"I")[0]
		assert 0 <= progress < 100
		return progress
	def player_coords(self):
		return EntityCoords(self.read_structured_memory(PLAYER_COORDS, "iii"))
	def player_target_entity_id(self):
		return EntityId(self.read_memory(PLAYER_TARGET_ID, 4))
	def player_entity(self):
		player_entity_id = self.player_entity_id()
		for entity in self.iter_entities():
			if entity.id == player_entity_id:
				return entity
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
		offset = 0
		data = self.read_memory(ENTITY_ARRAY_OFFSET, PAGE_ENTITY_LCD)
		while True:
			#data = self.read_memory(offset, ENTITY_STRUCT_SIZE)
			entity = Entity(data[offset:offset+ENTITY_STRUCT_SIZE])
			if not entity:
				break
			else:
				yield entity
			offset += ENTITY_STRUCT_SIZE
