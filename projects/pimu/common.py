import collections, random, select

DIRECTIONS = {
		"north": (0, -1),
		"northeast": (1, -1),
		"east": (1, 0),
		"southeast": (1, 1),
		"south": (0, 1),
		"southwest": (-1, 1),
		"west": (-1, 0),
		"northwest": (-1, -1)}

VIEWPORT_DIMENSIONS = (15, 11)

class Tile(object):
	def __init__(self, glyph):
		self.__glyph = glyph
	def walkable(self):
		return not self.__glyph is None and self.__glyph in ".,"
	def __repr__(self):
		return "Tile({0!r})".format(self.__glyph)
	def get_color(self):
		return {
				",": (0, 0xa0, 0),
				".": (0xc0, 0x80, 0x40),
				"0": (0x40, 0x40, 0x40),
				"T": (0, 0x80, 0),
				"o": (0x80, 0x80, 0x80),
				"R": (0xff, 0, 0),
				None: (0, 0, 0),
			}[self.__glyph]

class World(object):
	def __init__(self, data=None):
		if data is None:
			data = {}
		self.__data = data
	def set_tile(self, x, y, glyph):
		self.__data.setdefault(y, {})[x] = Tile(glyph)
	def get_tile(self, x, y):
		try:
			return self.__data[y][x]
		except KeyError:
			return Tile(None)
	def __getitem__(self, coords):
		return self.get_tile(*coords)
	def get_data(self):
		return self.__data
	def __repr__(self):
		return "{0}({1})".format(self.__class__.__name__, self.__data)
	def from_file(self):
		mapfile = open("level")
		for y, line in enumerate(mapfile):
			assert line[-1] == "\n"
			line = line[:-1]
			for x, tile in enumerate(line):
				self.set_tile(x, y, tile)

class Entity(object):
	__slots__ = "color", "coords", "id", "name", "health"
	def __init__(self, **kwargs):
		for name in kwargs:
			setattr(self, name, kwargs.get(name))
	def __repr__(self):
		return "{0}(**{1})".format(
				"Entity",
				dict((a, getattr(self, a)) for a in Entity.__slots__))

Message = collections.namedtuple("Message", ("title", "pdata", "kwdata"))

class SocketClosed(Exception):
	pass

class SocketMessageBuffer(object):
	def __init__(self, opensock):
		self.__inbuf = ""
		self.__outbuf = ""
		self.__socket = opensock
	def get_socket(self):
		return self.__socket
	def post_message(self, title, *pdata, **kwdata):
		self.__outbuf += repr((title, pdata, kwdata)) + "\x00"
	def get_message(self):
		try:
			index = self.__inbuf.index("\x00")
		except ValueError:
			return
		data = self.__inbuf[:index]
		self.__inbuf = self.__inbuf[index+1:]
		return Message(*eval(data))
	def flush(self):
		if self.pending_out():
			writefds = [self.__socket]
		else:
			writefds = []
		ready = select.select([self.__socket], writefds, [], 0)
		if ready[0]:
			if not self.receive_more():
				return False
		if ready[1]:
			self.send_pending()
		return True
	def send_pending(self):
		assert len(self.__outbuf) > 0
		sent = self.__socket.send(self.__outbuf)
		assert sent != 0
		self.__outbuf = self.__outbuf[sent:]
	def receive_more(self):
		data = self.__socket.recv(0x1000)
		if not data:
			raise SocketClosed()
		self.__inbuf += data
		return len(data) > 0
	def pending_out(self):
		return len(self.__outbuf) > 0
	def fileno(self):
		return self.__socket.fileno()

class Coords(object):
	__slots__ = "x", "y"
	def __init__(self, x=0, y=0):
		self.x = x
		self.y = y
	def __iter__(self):
		yield self.x
		yield self.y
	def __len__(self):
		return 2
	def __add__(self, other):
		assert len(other) == 2
		return Coords(self.x + other[0], self.y + other[1])
	def __getitem__(self, key):
		return [self.x, self.y][key]
	def __sub__(self, other):
		assert len(other) == 2
		return Coords(self.x - other[0], self.y - other[1])
	def __eq__(self, other):
		from itertools import izip
		for a, b in izip(self, other):
			if a != b:
				return False
		else:
			return True
	def __repr__(self):
		return "{0}(x={1!r}, y={2!r})".format(
				self.__class__.__name__,
				self.x,
				self.y)

class NoDupDict(dict):
	def __setitem__(self, key, value):
		assert key not in self
		dict.__setitem__(self, key, value)
