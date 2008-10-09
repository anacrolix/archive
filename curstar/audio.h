#include <glib/glist.h>
#include <glib/gtypes.h>

/* AudioPlayer */

typedef struct audio_player *AudioPlayer;

/* constructor/destructors */

AudioPlayer ap_new(GList *list);
void ap_free(AudioPlayer ap);

/* query functions */

gchar const *ap_current_uri(AudioPlayer ap);
gchar const *ap_state_to_string(AudioPlayer ap);
gchar const *ap_sink_factory_name(AudioPlayer ap);
gdouble ap_current_volume(AudioPlayer ap);

/* state changing functions */

void ap_volume_up(AudioPlayer ap);
void ap_volume_down(AudioPlayer ap);
gboolean ap_set_track(AudioPlayer ap, gint tracknr);
gboolean ap_toggle_play(AudioPlayer ap);
gboolean ap_next_track(AudioPlayer ap);
gboolean ap_prev_track(AudioPlayer ap);
