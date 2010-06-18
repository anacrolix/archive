import collections, random, select

DIRECTIONS = {
		'north': (0, -1),
		'east': (1, 0),
		'south': (0, 1),
		'west': (-1, 0),}

VIEWPORT_DIMENSIONS = (15, 11)

def walkable_glyph(glyph):
	return not glyph is None and glyph in ".,"

class Map(object):

	def __init__(self, data=None):
		if data is None:
			data = {}
		self.__data = data

	def set_tile(self, x, y, glyph):
		self.__data.setdefault(y, {})[x] = glyph

	def get_tile(self, x, y):
		try:
			return self.__data[y][x]
		except KeyError:
			return None

	def get_data(self):
		return self.__data

	def __repr__(self):
		return "Map({0})".format(self.__data)

class Entity(object):

	def __init__(self, color=None, coords=None, id=None):
		if color is None:
			color = (random.randint(0, 0xff), 0, random.randint(0, 0xff))
		if coords is None:
			coords = Coords()
		assert id is not None
		self.color = color
		self.coords = coords
		self.id = id

	def __repr__(self):
		return "Entity(**{0})".format(self.__dict__)

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
		"""DOES NOT BLOCK"""
		ready = select.select([self.__socket], [self.__socket], [], 0)
		if ready[0]:
			if not self.receive_more():
				return False
		if ready[1]:
			self.send_pending()
		return True

	def send_pending(self):
		if len(self.__outbuf) != 0:
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

	def __init__(self, x=0, y=0):
		self.x = x
		self.y = y

	def __iter__(self):
		yield self.x
		yield self.y

	def __add__(self, other):
		assert len(other) == 2
		return Coords(self.x + other[0], self.y + other[1])

	def __sub__(self, other):
		assert len(other) == 2
		return Coords(self.x - other[0], self.y - other[1])

	def __repr__(self):
		return "Coords(x=%r, y=%r)" % (self.x, self.y)
