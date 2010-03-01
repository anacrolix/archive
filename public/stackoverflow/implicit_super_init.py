class A(object):
    def __init__(self, a, b, c):
        #super(A, self).__init__()
        super(self.__class__, self).__init__()


class B(A):
    def __init__(self, b, c):
        print super(B, self)
        print super(self.__class__, self)
        #super(B, self).__init__(1, b, c)
        super(self.__class__, self).__init__(1, b, c)

class C(B):
    def __init__(self, c):
        #super(C, self).__init__(2, c)
        super(self.__class__, self).__init__(2, c)
C(3)
