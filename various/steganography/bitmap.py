import struct

class FancyStruct:

	def __init__(self, formats):
		# [(struct.Struct, member count)]
		self.structs = []
		for f in formats:
			self.structs.append((struct.Struct(f[0]), f[1]))

	def pack(self, data):
		rv = ""
		lower = 0
		for st in self.structs:
			upper = lower + st[1]
			print lower, upper, data[lower:upper]
			rv += st[0].pack(*data[lower:upper])
			lower = upper
		return rv

	def unpack(self, ab):
		rv = ()
		lower = 0
		for st in self.structs:
			upper = lower + st[0].size
			rv += st[0].unpack(ab[lower:upper])
			lower = upper
		assert lower == len(ab)
		return rv

class HeaderStruct:

	def __init__(self, st, ab=None):
		self.__st = st
		if not ab is None: self.unpack(ab)

	def pack(self):
		return self.__st.pack(self.data)

	def unpack(self, ab):
		self.data = self.__st.unpack(ab)
		self.verify(self.data)
		return self.data

	def verify(self, data):
		NotImplementedError

class BitmapFileHeader(HeaderStruct):

	MAGIC = 0
	SIZE = 1
	# 2 reserved fields
	OFFSET = 4

	def __init__(self, ab=None):
		HeaderStruct.__init__(
				self,
				FancyStruct([(">H", 1), ("<LhhL", 4)]),
				ab)

	def verify(self, data):
		assert data[self.MAGIC] == 0x424d
		assert data[self.OFFSET] >= 14
		assert data[self.SIZE] >= 14

class BitmapInfoHeader(HeaderStruct):

	HDR_SIZE = 0
	WIDTH = 1
	HEIGHT = 2
	PLANES = 3
	BITCOUNT = 4
	COMPRESSION = 5
	IMAGE_SIZE = 6
	HOR_RES = 7
	VERT_RES = 8
	CLR_USED = 9
	CLR_IMPORTANT = 10

	def __init__(self, ab=None):
		HeaderStruct.__init__(
				self, struct.Struct("<LllHHLLllLL"), ab)

	def verify(self, data):
		assert data[self.HDR_SIZE] == 40
		assert data[self.PLANES] == 1
		assert data[self.BITCOUNT] in [24]
		assert data[self.COMPRESSION] in [0]
		assert data[self.CLR_IMPORTANT] == 0

def unpack_pixels(data, bpp, width, height):
	assert bpp == 24 and bpp % 8 == 0
	rv = []
	offset = 0
	for j in range(height):
		for i in range(width):
			pixel = struct.unpack("BBB", data[offset:offset+3])
			offset += 3
			rv.append(pixel)
		offset += (4 - (width * 3) % 4) % 4
	return rv

def pack_pixels(pixels, bitcount, width, height):
	assert bitcount == 24
	rv = ""
	bytes_pp = {24: 3}[bitcount]
	for j in range(height):
		for i in range(width):
			if bitcount == 24:
				rv += struct.pack("BBB", *pixels[j * width + i])
			else: assert False
		rv += "\0" * ((4 - (width * bytes_pp) % 4) % 4)
	return rv

class Bitmap:

	def from_buf(self, buf):
		self.bmp_f_h = BitmapFileHeader(buf[0:14])
		self.bmp_info_h = BitmapInfoHeader(buf[14:54])
		self.pixels = unpack_pixels(
				buf[54:],
				self.bmp_info_h.data[BitmapInfoHeader.BITCOUNT],
				self.bmp_info_h.data[BitmapInfoHeader.WIDTH],
				self.bmp_info_h.data[BitmapInfoHeader.HEIGHT])
		assert buf[54:] == pack_pixels(
				self.pixels,
				self.bmp_info_h.data[BitmapInfoHeader.BITCOUNT],
				self.bmp_info_h.data[BitmapInfoHeader.WIDTH],
				self.bmp_info_h.data[BitmapInfoHeader.HEIGHT])
