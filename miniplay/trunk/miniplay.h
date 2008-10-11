#include <gtk/gtk.h>
#include <gst/gst.h>

/* initialization functions */

void init_audio();
void init_tray();

/* audio functions */

void set_music_directory(gchar *path);
void set_shuffle(gboolean shuffle);
void next_track();
void prev_track();
void delete_track();
void play_pause();

/* tray functions */

void pause_icon();
void play_icon();
