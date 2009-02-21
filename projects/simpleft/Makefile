CFLAGS = -std=c99 -D_XOPEN_SOURCE -Wall -g

default: simpleft

simpleft: main.o server.o client.o sockutil.o
	$(CC) -o $@ $^

clean:
	$(RM) *.o simpleft

*.o: *.h
