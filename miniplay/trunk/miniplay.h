#include <gio/gio.h>
#include <gtk/gtk.h>
#include <gst/gst.h>
#include <glib/gstdio.h>
#include <libnotify/notify.h>
#include "config.h"

/* audio functions */

void init_audio();
void set_music_directory(gchar *path);
void set_shuffle(gboolean shuffle);
void next_track();
void prev_track();
void delete_track();
void play_pause();
void set_volume(gdouble vol);

/* tray functions */

void init_tray();
GtkStatusIcon *mp_get_status_icon();
gboolean select_music(gpointer);
void pause_icon();
void play_icon();

/* libnotify */

void mp_notify_init();
void mp_notify_track(GstTagList const *tags);

/* configuration */

void mp_conf_init();
void mp_conf_save();

gboolean mp_conf_has_music_dir();
gchar const *mp_conf_get_music_dir();
void mp_conf_set_music_dir(gchar const *music_dir);

gdouble mp_conf_get_volume();
void mp_conf_set_volume(gdouble volume);
