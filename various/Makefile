CC = gcc
CFLAGS = -std=c99 -Wall -g -O2

EXES = buftest revbuf jackrev fib

all: clean ${EXES}

clean:
	-rm -fv *.o ${EXES}

jackrev: jackrev.hs
	if [ -x ghc ]; then ghc -O2 -fvia-C -optc-O2 --make jackrev.hs; fi
