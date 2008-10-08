PCLIBS = gstreamer-0.10
CFLAGS = -Wall `pkg-config --cflags $(PCLIBS)` -g -std=c99 -D_XOPEN_SOURCE=500
LDFLAGS = -lcurses `pkg-config --libs $(PCLIBS)`

all: curstar

curstar: main.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)

clean:
	$(RM) -fv *.o curstar

