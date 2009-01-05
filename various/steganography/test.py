#!/usr/bin/env python

import bitmap

bmp = bitmap.Bitmap()
bmp.from_buf(open("boobs.bmp", "r").read())
print len(bmp.pixels)
