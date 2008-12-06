PCLIBS = libpanelapplet-2.0
CPPFLAGS = `pkg-config --cflags $(PCLIBS)`
LDFLAGS = `pkg-config --libs $(PCLIBS)`
CFLAGS = -g -Wall

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
	dpkg -b build .
