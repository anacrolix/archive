PCLIBS = gtk+-2.0 gstreamer-0.10 libnotify
CFLAGS = -g -Wall -pedantic -Wno-unused-function -std=c99 \
		`pkg-config --cflags $(PCLIBS)` \
		$(EXTRA_CFLAGS)
LDFLAGS = `pkg-config --libs $(PCLIBS)`

all: clean miniplay

clean:
	$(RM) *.o miniplay

miniplay: main.o audio.o tray.o notify.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)
