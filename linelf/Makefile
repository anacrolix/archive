CFLAGS = -g -std=c99 -Wall -D_GNU_SOURCE

all : linelf

clean :
	-rm -vf linelf *.o matt/*.o

linelf : main.o matt/procmaps.o matt/pallocf.o matt/allocex.o
	$(CC) -o $@ $^
