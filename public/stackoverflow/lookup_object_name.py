class Foo(object):
    _all_names = {}
    def __init__(self, name=None):
        self.name = name
    @property
    def name(self):
        return self._name
    @name.setter
    def name(self, name):
        self._name = name
        self._all_names[name] = self
    @name.deleter
    def name(self):
        print "del Foo.name"
        del self._all_names[self.name]
    @classmethod
    def get_by_name(cls, name):
        return cls._all_names[name]
    @classmethod
    def del_by_name(cls, name):
        del cls._all_names[name]
    def __str__(self):
        return "Foo({0})".format(self.name)

a = Foo("alice")
b = Foo("bob")
print Foo.get_by_name("alice")
Foo.del_by_name("alice")
print Foo.get_by_name("alice")
