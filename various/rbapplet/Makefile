PCLIBS = dbus-glib-1 gtk+-2.0 libpanelapplet-2.0
CPPFLAGS = `pkg-config --cflags $(PCLIBS)`
LDFLAGS = `pkg-config --libs $(PCLIBS)`
CFLAGS = -g

default: rbapplet
tests: rb_delete_playing rb_track_name_owner
