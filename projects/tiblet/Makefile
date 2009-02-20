CC = g++
PCLIBS = libpanelapplet-2.0
LDFLAGS = `pkg-config --libs $(PCLIBS)`
CFLAGS = -g -Wall
CXXFLAGS = $(CFLAGS)
CPPFLAGS = `pkg-config --cflags $(PCLIBS)`

PREFIX = /usr

servers_dir = $(PREFIX)/lib/bonobo/servers
pixmaps_dir = $(PREFIX)/share/pixmaps
applet_dir = $(PREFIX)/lib/tiblet

applet: tiblet

configure:
	./configure

install: applet
	install -d $(servers_dir) $(pixmaps_dir) $(applet_dir)
	install -m 644 tiblet.server $(servers_dir)
	install -m 644 tiblet.xpm $(pixmaps_dir)
	install -m 755 tiblet $(applet_dir)

deb:
	-rm -rv build
	make install PREFIX="build${PREFIX}"
	install -d 'build/DEBIAN'
	install -m 644 control 'build/DEBIAN'
	fakeroot dpkg -b build .

tiblet.o: readuriasync.hpp
