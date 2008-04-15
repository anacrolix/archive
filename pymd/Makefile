CC = gcc
DBGFLAGS = --coverage
ALLFLAGS = $(DBGFLAGS)
CFLAGS = $(ALLFLAGS) -I'/usr/include/python2.4' -std=c99 -Wall -fpic -O2
LDFLAGS = $(ALLFLAGS) -lm -shared

all: md.so
	
clean:
	-rm -vf md.o md.so

md.so: md.o
	$(CC) -o $@ $^ $(LDFLAGS)
