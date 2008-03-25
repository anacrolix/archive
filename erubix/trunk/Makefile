CFLAGS = -Wall -O2 -std=c99
OBJS = erubix.o cube.o

target : erubix

clean :
	rm -v erubix *.o

erubix : $(OBJS)

erubix.o : erubix.c cube.h
cube.o : cube.h
