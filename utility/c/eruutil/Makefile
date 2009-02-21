CFLAGS = -std=c99 -Wall -g -D_XOPEN_SOURCE

all : clean test

clean :
	-rm -vf *.o

test : test.o procmaps.o pallocf.o allocex.o
