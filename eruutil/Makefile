CFLAGS = -std=c99 -O2

target : test bit-test

test : test.o bit.o

bit-test : bit-test.o bit.o

clean :
	rm -v test bit-test *.o
