PCLIBS = gtk+-2.0 gstreamer-0.10 #gio-2.0
CFLAGS = -g -Wall -std=c99 \
		`pkg-config --cflags $(PCLIBS)` \
		$(EXTRA_CFLAGS)
LDFLAGS = `pkg-config --libs $(PCLIBS)`

all: clean miniplay

clean:
	$(RM) *.o miniplay

miniplay: main.o audio.o tray.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)
