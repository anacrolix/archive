class OtherClass(object):

    def __init__(self, value):
        self.__value = value

    def __getattr__(self, name):
        return getattr(self.__value, name)

    def another(self):
        return self ** 2

class Container(object):

    def __init__(self, value):
        self.attr = OtherClass(value)

x = Container(2)
print x.attr
print x.attr.another()
