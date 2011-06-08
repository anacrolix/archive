from ctypes import *

funcspec = CFUNCTYPE(c_int, c_int, POINTER(c_int))

@funcspec
def callback(the_int, the_int_p):
    print(vars())
    return 3

print(callback(c_int(1), byref(c_int(2))))
