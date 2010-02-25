import collections

Killer = collections.namedtuple("Killer", ("isplayer", "name"))
CharDeath = collections.namedtuple("CharDeath", ("time", "level", "killers"))

class Character(object):
    _fields = ("name", "vocation", "level", "guild")
    def __init__(self, **kwargs):
        super(self.__class__, self).__init__()
        self.__data = {}
        for k, v in kwargs.items():
            self[k] = v
    def __setitem__(self, key, value):
        assert key in self._fields
        assert key not in self.__data
        self.__data[key] = value
    def __getattr__(self, name):
        if name in self._fields:
            return self.__data.get(name)
        else:
            raise AttributeError()
    def update(self, other):
        vars(self).update(vars(other))
    def is_online(self):
        return self.online
    def set_online(self, online, stamp):
        if not hasattr(self, "online"):
            self.last_status_change = stamp if online else 0
        elif online != self.online:
            self.last_status_change = stamp
        self.online = online
    def last_online(self):
        assert not self.online
        return self.last_status_change
    def last_offline(self):
        assert self.online
        return self.last_status_change
    def __ne__(self, other):
        return not self == other
    def __eq__(self, other):
        for a in self._fields:
            if getattr(self, a) != getattr(other, a):
                return False
        else:
            return True
    def __repr__(self):
        return "{0}({1})".format(self.__class__.__name__, ", ".join(("{0}={1!r}".format(f, getattr(self, f)) for f in self._fields)))
