#include <gtk/gtk.h>
#include <gst/gst.h>

void init_audio();
void init_tray();

void set_music_directory(gchar *path);
void next_track();
void prev_track();
void play_pause();

void blink_tray(gboolean blink);
