import tempfile, os
f = tempfile.TemporaryFile()
f.write(os.urandom(10000000))
f.flush()
BUFSIZE = 10000000
def read():
    f.seek(0)
    s = b''
    while True:
        b = f.read(BUFSIZE)
        if not b:
            break
        s += b
    return s
def bytearray_read():
    f.seek(0)
    s = bytearray()
    while True:
        b = f.read(BUFSIZE)
        if not b:
            break
        s += b
    return s
ba = bytearray(os.fstat(f.fileno()).st_size)
mv = memoryview(ba)
def readinto():
    f.seek(0)
    #~ s = bytearray(os.fstat(f.fileno()).st_size)
    o = 0
    while True:
        b = f.readinto(mv[o:o+BUFSIZE])
        if not b:
            break
        o += b
    return mv
if __name__ == '__main__':
    assert read() == bytearray_read() == readinto()
