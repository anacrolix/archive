CFLAGS = -Wall `pkg-config --cflags gstreamer-0.10` -g -std=c99 -D_XOPEN_SOURCE
LDFLAGS = -lcurses `pkg-config --libs gstreamer-0.10`

all: curstar

curstar: main.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)

clean:
	$(RM) -fv *.o curstar
