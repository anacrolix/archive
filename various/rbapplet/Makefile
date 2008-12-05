PCLIBS = dbus-glib-1 gtk+-2.0 libpanelapplet-2.0
CPPFLAGS = `pkg-config --cflags $(PCLIBS)`
LDFLAGS = `pkg-config --libs $(PCLIBS)`
CFLAGS = -g

server_path := /usr/lib/bonobo/servers
server_file := rbapplet.server
applet_exe := rbapplet

default: applet server

applet: rbapplet

server: $(server_path)/$(server_file)
$(server_path)/$(server_file): $(server_file)
	sudo ln -sf $(PWD)/$(server_file) $(server_path)

deb:
