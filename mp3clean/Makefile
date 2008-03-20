# flags: NDEBUG, NO_FRAME_SYNC
CFLAGS = -Wall -g
CXXFLAGS = $(CFLAGS)
LDFLAGS = -lssl
OBJECTS = mp3clean.o mpegamm.o
TARGETS = mp3clean

target: $(TARGETS)

clean:
	rm -vf $(TARGETS) $(OBJECTS)

mp3clean: $(OBJECTS)
	g++ -o $@ $(OBJECTS) $(LDFLAGS)
