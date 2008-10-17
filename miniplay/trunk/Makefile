PCLIBS = gtk+-2.0 gstreamer-0.10 libnotify
CFLAGS = -g -Wall -pedantic -Wno-unused-function -std=c99 \
		`pkg-config --cflags $(PCLIBS)` \
		$(EXTRA_CFLAGS)
LDFLAGS = `pkg-config --libs $(PCLIBS)`
INSTALL = install

all: clean miniplay

clean:
	$(RM) *.o miniplay

miniplay: main.o audio.o tray.o notify.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)
	
install:
	$(INSTALL) -m 755 miniplay $(DESTDIR)/bin
	$(INSTALL) -m 644 play-icon.svg $(DESTDIR)/share/miniplay
	$(INSTALL) -m 644 BUGS COMPILE CREDITS $(DESTDIR)/share/doc/miniplay

