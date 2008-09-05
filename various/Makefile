CC = gcc
CFLAGS = -std=c99 -Wall -g

EXES = buftest revbuf jackrev

all: clean ${EXES}

clean:
	-rm -fv *.o ${EXES}

jackrev: jackrev.hs
	ghc -O2 -fvia-C -optc-O2 --make jackrev.hs
