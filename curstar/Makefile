PCLIBS = gstreamer-0.10
CFLAGS = -Wall -pedantic -std=c99  -g \
	-D_XOPEN_SOURCE=500 `pkg-config --cflags $(PCLIBS)`
# -Wextra
LDFLAGS = -lcurses `pkg-config --libs $(PCLIBS)`

all: curstar

curstar: main.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)

clean:
	$(RM) -fv *.o curstar

