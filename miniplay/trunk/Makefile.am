bin_PROGRAMS = miniplay
miniplay_SOURCES = main.c tray.c notify.c audio.c
miniplay_CPPFLAGS = -I`pkg-config --cflags gtk+-2.0 gstreamer-0.10 libnotify`
miniplay_CFLAGS = -std=c99
miniplay_LDFLAGS = -L`pkg-config --libs gtk+-2.0 gstreamer-0.10 libnotify`
iconsdir = $(datadir)/miniplay
icons_DATA = play-icon.svg
menudir = $(datadir)/applications
menu_DATA = miniplay.desktop
