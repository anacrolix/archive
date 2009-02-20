PCLIBS = gstreamer-0.10 glib-2.0
CFLAGS = -Wall -Wextra -pedantic -std=c99  -g \
	-D_XOPEN_SOURCE=500 `pkg-config --cflags $(PCLIBS)`
# -Wextra
LDFLAGS = -lcurses `pkg-config --libs $(PCLIBS)`

all: curstar

curstar: main.o audio.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)

clean:
	$(RM) -fv *.o curstar

main.o audio.o: audio.h
