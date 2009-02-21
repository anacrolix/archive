CFLAGS = -Wall -O2 -g

all : test

clean :
	rm -v test *.o

test : ringbuf.o

ringbuf.o : ringbuf.h
test.o : ringbuf.h
*.o : eruutil/erudebug.h
