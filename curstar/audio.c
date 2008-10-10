#include "audio.h"
#include <gst/gst.h>

/* used for 64bit nanosecond arithmetic */
#define E9 1000000000LL

struct audio_player {
	GList *list; /* playlist: list of uri's */
	gint index; /* current song index */
	GstTagList *tags; /* tag list of current song */
	gchar const *uri; /* currently playing song uri */
	GMainLoop *loop; /* loop passing bus events */
	gchar *sinkfn; /* the sink factory name */
	GstElement *pipe; /* "playbin" core plugin instance */
	GThread *thread; /* runs the main loop, and event handling */
};

static gboolean set_state_blocking(AudioPlayer ap, GstState state);
static char const *gst_state_to_string(GstState state);

/* constructor/destructors */

/** allocate space for the AudioPlayer contents */
static struct audio_player * ap_alloc()
{
	return malloc(sizeof(struct audio_player));
}

/** receive and process messages on the playbin bus */
static gboolean bus_watch(GstBus *bus, GstMessage *msg, gpointer data)
{
	AudioPlayer ap = data;
	(void)bus;

	switch (GST_MESSAGE_TYPE(msg)) {
		case GST_MESSAGE_ERROR: {
			/* write the error to stderr */
			GError *e;
			gst_message_parse_error(msg, &e, NULL);
			g_printerr("%s: %s: %s\n", ap->uri, GST_MESSAGE_TYPE_NAME(msg), e->message);
			g_error_free(e);
			set_state_blocking(ap, GST_STATE_NULL);
		}
		break;
		case GST_MESSAGE_TAG: {
			/* merge in new tags */
			GstTagList *tl;
			gst_message_parse_tag(msg, &tl);
			gst_tag_list_insert(ap->tags, tl, GST_TAG_MERGE_REPLACE);
			gst_tag_list_free(tl);
		}
		break;
#if 0
		case GST_MESSAGE_STATE_CHANGED: {
			GstState oldstate, newstate, pending;
			gst_message_parse_state_changed(msg, &oldstate, &newstate, &pending);
			g_printerr("%s: %s: %s->%s->%s\n", ap->uri,
					GST_MESSAGE_TYPE_NAME(msg),
					gst_state_to_string(oldstate),
					gst_state_to_string(newstate),
					gst_state_to_string(pending));
		}
		break;
#endif
		default:
		break;
	}
	/* continue watching the bus */
	return TRUE;
}

/** find and use an audiosink */
static GstElement *get_audio_sink(gchar **name)
{
	GstElement *sink = NULL;
	gchar const *sink_factory_names[] =
		{ "gconfaudiosink", "autoaudiosink", "alsasink", NULL };

	/* get an audio sink */
	gchar const **sfn = sink_factory_names;
	do {
		sink = gst_element_factory_make(*sfn, NULL);
	} while (!sink && *++sfn);

	if (sfn && name) *name = g_strdup(*sfn);
	return sink;
}

/** build a playbin pipeline, assigning bus and sink */
static GstElement *new_pipeline(AudioPlayer ap, gchar **sink_factory_name)
{
	GstElement *pipe = gst_element_factory_make("playbin", NULL);
	if (!pipe) {
		/* todo: error message */
		return NULL;
	}

	/* add watch to bus for pipeline events */
	GstBus *bus = gst_pipeline_get_bus(GST_PIPELINE(pipe));
	g_assert(bus);
	gst_bus_add_watch(bus, bus_watch, ap);
	gst_object_unref(bus);

	GstElement *sink = get_audio_sink(sink_factory_name);
	if (sink) {
		g_object_set(pipe, "audio-sink", sink, "video-sink", NULL, NULL);
		return pipe;
	} else {
		/* todo: how to destroy pipe? */
		return NULL;
	}
}

/** initialize a new AudioPlayer */
AudioPlayer ap_new(GList *list)
{
	AudioPlayer ap = ap_alloc();

	ap->list = list;
	ap->index = -1;
	ap->tags = gst_tag_list_new();
	ap->uri = NULL;
	ap->loop = g_main_loop_new(NULL, FALSE);
	ap->pipe = new_pipeline(ap, &ap->sinkfn);
	ap->thread = g_thread_create(
			(GThreadFunc)g_main_loop_run, ap->loop, TRUE, NULL);

	return ap;
}

void free_playlist(GList *list)
{
	while (list) {
		g_free(list->data);
		list = g_list_delete_link(list, list);
	}
}

static gboolean idle_loop_quit(gpointer data)
{
	g_main_loop_quit((data));
	return FALSE;
}

/** shutdown and destroy an AudioPlayer */
void ap_free(AudioPlayer ap)
{
	set_state_blocking(ap, GST_STATE_NULL);
	//g_main_loop_quit(ap->loop);
	g_idle_add(idle_loop_quit, ap->loop);
	g_thread_join(ap->thread);
	gst_object_unref(ap->pipe);
	gst_tag_list_free(ap->tags);
	/* uri's string is destroyed with this list */
	free_playlist(ap->list);
	g_free(ap);
}

/* query functions */

static char const *gst_state_to_string(GstState state)
{
	switch (state) {
		case GST_STATE_VOID_PENDING: return "No change";
		case GST_STATE_NULL: return "Stopped";
		case GST_STATE_READY: return "Ready";
		case GST_STATE_PAUSED: return "Paused";
		case GST_STATE_PLAYING: return "Playing";
		default: g_return_val_if_reached(NULL);
	}
}

static char const *gst_state_transition_to_string(GstStateChange change)
{
	switch (change) {
		case GST_STATE_CHANGE_NULL_TO_READY: return "Initializing";
		case GST_STATE_CHANGE_READY_TO_PAUSED: return "Loading";
		case GST_STATE_CHANGE_PAUSED_TO_PLAYING: return "Starting";
		case GST_STATE_CHANGE_PLAYING_TO_PAUSED: return "Pausing";
		case GST_STATE_CHANGE_PAUSED_TO_READY: return "Stopping";
		case GST_STATE_CHANGE_READY_TO_NULL: return "Deallocating";
		default: g_return_val_if_reached(NULL);
	}
}

gchar const *ap_sink_factory_name(AudioPlayer ap)
{
	return ap->sinkfn;
}

gdouble ap_current_volume(AudioPlayer ap)
{
	gdouble vol;
	g_object_get(ap->pipe, "volume", &vol, NULL);
	return 100.0 * vol;
}

gchar const *ap_state_to_string(AudioPlayer ap)
{
	GstState state = GST_STATE(ap->pipe);
	GstState pending = GST_STATE_PENDING(ap->pipe);

	if (pending != GST_STATE_VOID_PENDING) {
		g_assert(state != pending);
		return gst_state_transition_to_string(GST_STATE_TRANSITION(state, pending));
	} else {
		return gst_state_to_string(state);
	}
}

gchar const *ap_current_uri(AudioPlayer ap)
{
	return ap->uri;
}

gchar *ap_get_tag(AudioPlayer ap, gchar const *tag)
{
	gchar *value;
	gboolean exists;
	switch (gst_tag_get_type(tag)) {
		case G_TYPE_STRING:
			exists = gst_tag_list_get_string(ap->tags, tag, &value);
		break;
		default:
			g_return_val_if_reached(NULL);
	}
	if (exists) return value;
	else return NULL;
}

/* state changing functions */

static void ap_volume_adjust(AudioPlayer ap, gdouble adj)
{
	gdouble vol;
	g_object_get(ap->pipe, "volume", &vol, NULL);
	vol += adj;
	if (vol > 1.0) vol = 1.0;
	else if (vol < 0.0) vol = 0.0;
	g_object_set(ap->pipe, "volume", vol, NULL);
}

void ap_volume_up(AudioPlayer ap)
{
	ap_volume_adjust(ap, +0.1);
}

void ap_volume_down(AudioPlayer ap)
{
	ap_volume_adjust(ap, -0.1);
}

static gboolean set_state_blocking(AudioPlayer ap, GstState state)
{
	GstStateChangeReturn sc_ret;
	sc_ret = gst_element_set_state(ap->pipe, state);
	switch (sc_ret) {
		case GST_STATE_CHANGE_FAILURE:
		return FALSE;
		case GST_STATE_CHANGE_ASYNC: {
			GstState curstate;
			do {
				sc_ret = gst_element_get_state(
						ap->pipe, &curstate, NULL, GST_CLOCK_TIME_NONE);
			} while (sc_ret == GST_STATE_CHANGE_ASYNC);
			if (sc_ret != GST_STATE_CHANGE_FAILURE &&
					curstate == state)
				return TRUE;
			else
				return FALSE;
		}
		default:
		return TRUE;
	}
}

gboolean ap_set_track(AudioPlayer ap, gint tracknr)
{
	/* get the desired play state after track change */
	GstState target = MAX(GST_STATE_TARGET(ap->pipe), GST_STATE_PAUSED);

	/* stop the current pipeline and set new track */
	if (!set_state_blocking(ap, GST_STATE_NULL)) return FALSE;

	/* prepare status vars */
	ap->index = tracknr;
	ap->uri = g_list_nth_data(ap->list, tracknr);
	gst_tag_list_free(ap->tags);
	ap->tags = gst_tag_list_new();
	g_object_set(ap->pipe, "uri", ap->uri, NULL);

	/* resume previous pipeline state */
	return set_state_blocking(ap, target);
}

gboolean ap_toggle_play(AudioPlayer ap)
{
	GstState state =
			(GST_STATE(ap->pipe) == GST_STATE_PLAYING)
			? GST_STATE_PAUSED : GST_STATE_PLAYING;
	return set_state_blocking(ap, state);
}

gboolean ap_next_track(AudioPlayer ap)
{
	guint n = ap->index + 1;
	if (g_list_nth(ap->list, n))
		return ap_set_track(ap, n);
	else
		return ap_set_track(ap, 0);
}

gboolean ap_prev_track(AudioPlayer ap)
{
	guint n = ap->index - 1;
	if (g_list_nth(ap->list, n))
		return ap_set_track(ap, n);
	else
		return ap_set_track(ap, g_list_length(ap->list) - 1);
}
