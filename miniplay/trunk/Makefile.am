bin_PROGRAMS = miniplay

miniplay_SOURCES = main.c tray.c notify.c audio.c
miniplay_CPPFLAGS = $(gtk_CFLAGS) $(gstreamer_CFLAGS) \
	$(libnotify_CFLAGS) $(gio_CFLAGS)
miniplay_CFLAGS = -std=c99
miniplay_LDFLAGS = $(gtk_LIBS) $(gstreamer_LIBS) $(libnotify_LIBS) \
	$(gio_LIBS)

iconsdir = $(datadir)/miniplay
icons_DATA = play-icon.svg
menudir = $(datadir)/applications
menu_DATA = miniplay.desktop
