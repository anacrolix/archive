from time import time

def fact_gen():
    a = 1
    b = 1
    while True:
        a *= b
        yield a
        b += 1
        
def factorial(n):
    a = fact_gen()
    while n > 1:
        next(a)
        n -= 1
    return next(a)
        

start = time()
for a in reversed(range(1, 51)):
    print(factorial(a))
    #factorial(a)
print(time() - start)
