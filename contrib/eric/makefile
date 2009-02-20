CC = gcc
CFLAGS = -Wall -g -D_REENTRANT

all: server.exe client.exe

server.exe: server.o threadpool.o
	$(CC) $^ -o $@ -lpthread $(CFLAGS)

threadpool.o: threadpool.c
	$(CC) $< -c -o $@ $(CFLAGS)

server.o: server.c
	$(CC) $< -c -o $@ $(CFLAGS)

client.exe: client.o
	$(CC) $^ -o $@ -g $(CFLAGS)

client.o: client.c
	$(CC) $< -c -o $@ -g $(CFLAGS)

clean:
	-$(RM) *.o server.exe client.exe
