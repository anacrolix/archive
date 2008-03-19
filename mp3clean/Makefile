CC = gcc
CFLAGS = -Wall -std=c99 -O2 -DNDEBUG #-DNO_FRAME_SYNC
LDFLAGS = -lssl

target: mp3clean

clean:
	rm -vf mp3clean *.o ../eruutil/*.o
	
mp3clean: mp3clean.o ../eruutil/strrchr.o ../eruutil/memnotchr.o
