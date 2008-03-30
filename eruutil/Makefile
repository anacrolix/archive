CFLAGS = -std=c99 -O2

target : test bit-test

test : test.o bit.o

bit-test : bit.o bit.h
bit.o : bit.h

clean :
	rm -v test bit-test *.o
