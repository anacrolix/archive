PCLIBS = gtk+-2.0
CFLAGS = -g -Wall \
		`pkg-config --cflags $(PCLIBS)`
LDFLAGS = `pkg-config --libs $(PCLIBS)`

all: clean miniplay

clean:
	$(RM) *.o miniplay

miniplay: tray.o
	$(CC) -o $@ $^ $(LDFLAGS)
