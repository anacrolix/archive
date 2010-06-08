class Level(object):
	def __init__(self, intval, strval):
		self._intval = intval
		self._strval = strval
		object.__init__(self)
	def __cmp__(self, other):
		return cmp(self._intval, other)
	def __str__(self):
		return self._strval

def add_level(intval, strval):
	assert not strval in globals()
	globals()[strval] = Level(intval, strval)

for args in [
		(0, "INFO"),
		(1, "ATTEND"),
		(2, "DANGER"),
		(3, "CRITICAL"),]:
	add_level(*args)

assert None < INFO < ATTEND < DANGER < CRITICAL
