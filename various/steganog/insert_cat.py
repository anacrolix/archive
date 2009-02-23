import os

hidden_f = open("hidden.bmp", "r")
cover_f = open("cover.bmp", "r")
output_f = open("message.bmp", "w")

# copy the bitmap headers
output_f.write(cover_f.read(54))
hidden_f.seek(54, os.SEEK_SET)

while True:
    cover_b = cover_f.read(1)
    hidden_b = hidden_f.read(1)
    if not cover_b and not hidden_b:
        break
    output_b = chr((ord(cover_b) & 0xfc) | (ord(hidden_b) / 64))
    output_f.write(output_b)

assert hidden_f.tell() == output_f.tell() == cover_f.tell()
