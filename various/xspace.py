import sys
while True:
    c = sys.stdin.read(1)
    if not c:
        break
    if not c.isspace():
        c = 'X'
    sys.stdout.write(c)
