CFLAGS = -Wall -std=c99 -g
LDFLAGS = -lssl

target: mp3clean

clean:
	rm -vf mp3clean *.o ../eruutil/*.o
	
mp3clean: ../eruutil/strrchr.o mp3clean.o
