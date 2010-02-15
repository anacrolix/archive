#!/usr/bin/env python

import cStringIO, StringIO # comment this for python3
import io, pdb, tempfile, zipfile

MEMBER_NAME = "member"
MEMBER_CONTENTS = b"Hello world"

def extract_member(f):
    z = zipfile.ZipFile(f)
    m = z.open(MEMBER_NAME)
    assert m.read() == MEMBER_CONTENTS

def main():
    t = tempfile.NamedTemporaryFile(suffix="zip", prefix="test")

    z = zipfile.ZipFile(t, 'w')
    z.writestr("member", "Hello world")
    z.close()

    for membuf in (
            StringIO.StringIO, cStringIO.StringIO, # comment this for python3
            io.BytesIO,):
        print("testing", membuf)
        t.seek(0)
        extract_member(membuf(t.read()))

if __name__ == "__main__":
    main()
