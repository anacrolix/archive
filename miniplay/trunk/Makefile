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
	mkdir -p $(DESTDIR)usr/{bin,share{,/doc}/miniplay}
	$(INSTALL) -m 755 -t $(DESTDIR)usr/bin miniplay
	$(INSTALL) -m 644 -t $(DESTDIR)usr/share/miniplay play-icon.svg
	$(INSTALL) -m 644 -t $(DESTDIR)usr/share/doc/miniplay \
			BUGS COMPILE CREDITS
