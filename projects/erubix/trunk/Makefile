CFLAGS = -Wall -O2 -std=c99
OBJS = erubix.o cube.o

target : erubix

clean :
	rm -v erubix *.o

erubix : $(OBJS)

erubix.o cube.o : cube.h eruutil/erudebug.h
#erubix.o cube.o : eruutil/erudebug.h
