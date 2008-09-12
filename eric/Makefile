CC = gcc
CFLAGS = -Wall

all: carpark.exe

carpark.exe: carpark.o
	$(CC) $^ -o $@ -lpthread

carpark.o: assignment1.c
	$(CC) $< -c -o $@

clean:
	-$(RM) *.o carpark.exe
