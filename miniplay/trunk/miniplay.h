#include <gio/gio.h>
#include <gtk/gtk.h>
#include <gst/gst.h>
#include <libnotify/notify.h>

/* initialization functions */

void init_audio();
void init_tray();
void mp_notify_init();
void connect_tray_signals();

/* audio functions */

void set_music_directory(gchar *path);
void set_shuffle(gboolean shuffle);
void next_track();
void prev_track();
void delete_track();
void play_pause();
void set_volume(gdouble vol);

/* tray functions */

GtkStatusIcon *mp_get_status_icon();
void select_music();
void pause_icon();
void play_icon();

/* libnotify */

void mp_notify_track(GstTagList const *tags);
