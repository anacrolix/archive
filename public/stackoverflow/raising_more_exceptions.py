class A(Exception): pass
class B(Exception): pass

try:
    try:
        raise A('first')
    finally:
        raise B('second')
except X as c:
    print(c)
