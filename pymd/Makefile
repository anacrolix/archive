#DBGFLAGS = --coverage -pg
CPUARCH = pentium4
#ALLFLAGS = 
CFLAGS = $(ALLFLAGS) -I'/usr/include/python2.4' -std=c99 -Wall -fpic -O3 -march=$(CPUARCH)
LDFLAGS = $(ALLFLAGS) -shared

all: md.so
	
clean:
	-rm -vf md.o md.so

md.so: md.o
	$(CC) -o $@ $^ $(LDFLAGS)
