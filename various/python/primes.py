import itertools
import math
import sys

def primes(n):
    sofar = []
    def isprime(p):
        s = int(math.sqrt(p))
        for q in sofar:
            if q > s:
                break
            if not p % q:
                return False
        sofar.append(p)
        return True
    def tocheck():
        yield 2
        yield 3
        for i in itertools.count(6, 6):
            yield i - 1
            yield i + 1
    for i in tocheck():
        if i > n:
            break
        if isprime(i):
            yield i

for p in primes(int(sys.argv[1])):
    print(p)
