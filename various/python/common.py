import math

def ispow2(value):
    return not math.modf(math.log(value, 2))[0]

class Buffer:
    def __init__(self, initial=""):
        self.s = initial
    #def size(self):
    #    return len(self.s)
    def ready(self, size):
        assert size >= 0
        return len(self.s) >= size
    def take(self, exact=None, min=None, max=None):
        assert bool(exact) ^ bool(min or max)
        if exact:
            min = exact
            max = exact
        if len(self) < min:
            return None
        else:
            r = self.s[:max]
            self.s = self.s[max:]
            return r
    def empty(self):
        rv = self.s
        self.s = ""
        return rv
    def append(self, data):
        self.s += data
    def drop(self, size):
        assert self.ready(size)
        self.s = self.s[size:]
    def copy(self):
        return self.s
    def __len__(self):
        return len(self.s)
