class Value(object):
    def __init__(self, initial=0):
        self.a = initial
    def __iadd__(self, other):
        self.a += other
        return self
    def __str__(self):
        return str(self.a)

class Blah(object):
    def __init__(self):
        self.__data = {}
    def __getitem__(self, key):
        return self.__data.setdefault(key, Value())

a = Blah()
b = a[1]
b += 1
print a[1]
a[1] += 2
print a[1]
