import itertools

class _EnumValue(object):
	def __init__(self, groupid, value):
		self.__groupid = groupid
		self.__value = value
	def __nonzero__(self):
		#return self.__value
		raise NotImplemented
	def __cmp__(self, other):
		if not isinstance(other, self.__class__):
			raise TypeError()
		elif self.__groupid != other.__groupid:
			raise ValueError()
		else:
			return cmp(self.__value, other.__value)

class _EnumGroup(object):
	def __init__(self, groupid, *values):
		for value, name in enumerate(values, 1):
			setattr(self, name, _EnumValue(groupid, value))

class _EnumFactory(object):
	def __init__(self):
		self.__groupgen = itertools.count(1)
	def __call__(self, *values):
		return _EnumGroup(self.__groupgen.next(), *values)

enum = _EnumFactory()

import unittest

class _TestEnum(unittest.TestCase):
	def setUp(self):
		self.Pet = enum("dog", "cat")
		self.Vehicle = enum("car", "bike", "bus", "plane")
	def test_same_group_equality(self):
		self.assert_(self.Pet.dog != self.Pet.cat)
		self.assert_(self.Pet.cat == self.Pet.cat)
		self.assert_(self.Pet.dog == self.Pet.dog)
		self.assert_(self.Vehicle.car != self.Vehicle.bike)
		self.assert_(self.Vehicle.bus == self.Vehicle.bus)
	def test_different_group_equality(self):
		# same values, different groupid
		self.assertRaises(ValueError, lambda: self.Pet.dog == self.Vehicle.car)
		# different everything
		self.assertRaises(ValueError, lambda: self.Pet.cat != self.Vehicle.plane)
	def test_zero_value(self):
		self.assertFalse(self.Pet.dog)
		self.assertTrue(self.Pet.cat)

if __name__ == "__main__":
	unittest.main()
