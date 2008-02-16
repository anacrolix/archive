CC = gcc
CFLAGS = -Wall -std=c99

all: server client

server: server.o network.o error.o
	$(CC) $(CFLAGS) -o server server.o network.o error.o
	
client: client.o network.o error.o
	$(CC) $(CFLAGS) -o client client.o network.o error.o
	
clean:
	rm -f *.o server client
	
server.o client.o: network.h error.h
network.o: error.h
