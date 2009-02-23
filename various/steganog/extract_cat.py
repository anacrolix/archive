in_f = open("message.bmp", "r")
out_f = open("secret.bmp", "w")

out_f.write(in_f.read(54))
while True:
    # read a bitmap color component
    val = in_f.read(1)
    if not val: break # EOF
    val2 = chr(64 * (ord(val) & 3))
    assert len(val2) == 1
    out_f.write(val2)

assert in_f.tell() == out_f.tell()
