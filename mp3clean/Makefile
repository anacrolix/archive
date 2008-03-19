CFLAGS = -Wall #-O2 -DNDEBUG #-DNO_FRAME_SYNC
CXXFLAGS = $(CFLAGS)
LDFLAGS = -lssl
OBJECTS = mp3clean.o ../eruutil/strrcasestr.o ../eruutil/memnotchr.o

target: mp3clean

clean:
	rm -vf mp3clean *.o ../eruutil/*.o

mp3clean: $(OBJECTS)
	g++ -o $@ $(OBJECTS) $(LDFLAGS)
