class A:

    def __init__(self):
        print('init')
        raise Exception('doh')
        self.a = 3

    def __del__(self):
        print('del')
        print(self.a)

A()
