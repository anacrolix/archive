#
CC 	= icc
CFLAGS = -pthread  
LDFLAGS	= -lm

all:		mysort

mysort:		mysort.o dont_change.o headers.h stack.h stack.o 
		$(CC) $(CFLAGS) -o $@ $@.o dont_change.o stack.o $(LDFLAGS)

stack.o: stack.c stack.h
	$(CC) $(CFLAGS) -c stack.c

dont_change.o: dont_change.c headers.h
	$(CC) $(CFLAGS) -c dont_change.c

.SUFFIXES: .c .o
.c.o:
	$(CC) $(CFLAGS) -c $*.c    

clean:
	rm *.o mysort *~


