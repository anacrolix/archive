#include "miniplay.h"
#include <gst/gst.h>

GstElement *playbin_pipe = NULL;
GList *music_uri_list = NULL;
gint current_track = -1;
GstTagList *tags_ = NULL;
gboolean shuffle_;

void set_shuffle(gboolean shuffle)
{
	shuffle_ = shuffle;
}

static gchar const *
current_uri()
{
	return g_list_nth_data(music_uri_list, current_track);
}

static GList *
build_music_list(GList *list, gchar *path)
{
	GDir *dir = g_dir_open(path, 0, NULL);
	if (!dir) {
		gchar *uri;
		if (g_path_is_absolute(path)) {
			uri = g_strconcat("file://", path, NULL);
		} else {
			gchar *wd = g_get_current_dir();
			gchar *abs = g_build_filename(wd, path, NULL);
			g_free(wd);
			uri = g_strconcat("file://", abs, NULL);
			g_free(abs);
		}
		list = g_list_prepend(list, uri);
	} else {
		gchar const *name;
		while ((name = g_dir_read_name(dir))) {
			gchar *sub = g_build_filename(path, name, NULL);
			list = build_music_list(list, sub);
			g_free(sub);
		}
		g_dir_close(dir);
	}
	return list;
}

static void
free_music_list()
{
	while (music_uri_list) {
		g_free(music_uri_list->data);
		music_uri_list = g_list_delete_link(music_uri_list, music_uri_list);
	}
}

void
set_music_directory(gchar *path)
{
	/* build track uri list */
	GList *list = build_music_list(NULL, path);
	list = g_list_reverse(list);

	/* halt current play */
	g_assert(gst_element_set_state(playbin_pipe, GST_STATE_NULL) == GST_STATE_CHANGE_SUCCESS);

	free_music_list();
	music_uri_list = list;

	if (g_list_length(music_uri_list) > 0) {
		current_track = 0;
		g_object_set(playbin_pipe, "uri", g_list_nth_data(music_uri_list, 0), NULL);
		gst_element_set_state(playbin_pipe, GST_STATE_PLAYING);
	} else {
		current_track = -1;
		g_object_set(playbin_pipe, "uri", NULL, NULL);
	}
}

static void
index_test(GstTagList const *list, gchar const *tag, gpointer user)
{
	g_debug("%s: %s", tag, g_type_name(gst_tag_get_type(tag)));
}

/** receive and process messages on the playbin bus */
static gboolean
bus_watch(GstBus *bus, GstMessage *msg, gpointer data)
{
	switch (GST_MESSAGE_TYPE(msg)) {
		case GST_MESSAGE_ERROR: {
			/* write the error to stderr */
			GError *e;
			gst_message_parse_error(msg, &e, NULL);
#if 0
			g_printerr("%s: %s: %s\n",
					current_uri(),
					GST_MESSAGE_TYPE_NAME(msg),
					e->message);
#endif
			g_error_free(e);
			next_track();
		}
		break;
		case GST_MESSAGE_TAG: {
			/* merge in new tags */
			GstTagList *tl;
			gst_message_parse_tag(msg, &tl);
#if 0
			g_debug("uri: %s", current_uri());
			gst_tag_list_foreach(tl, index_test, NULL);
#endif
			gst_tag_list_insert(tags_, tl, GST_TAG_MERGE_REPLACE);
			gst_tag_list_free(tl);
		}
		break;
		case GST_MESSAGE_STATE_CHANGED: {
			GstState state;
			gst_message_parse_state_changed(msg, NULL, &state, NULL);
			blink_tray(state == GST_STATE_PAUSED);
		}
		break;
		case GST_MESSAGE_EOS:
			next_track();
		break;
		default:
		break;
	}
	/* continue watching the bus */
	return TRUE;
}


/** find and use an audiosink */
static GstElement *
make_audio_sink()
{
	GstElement *sink = NULL;
	gchar const *sink_factory_names[] =
		{ "gconfaudiosink", "autoaudiosink", "alsasink", NULL };

	/* get an audio sink */
	gchar const **sfn = sink_factory_names;
	do {
		sink = gst_element_factory_make(*sfn, NULL);
	} while (!sink && *++sfn);

	g_debug("audio sink: %s", *sfn);
	return sink;
}

/** build a playbin pipeline, assigning bus and sink */
static GstElement *
create_pipeline()
{
	/* create the pipeline */
	GstElement *pipe = gst_element_factory_make("playbin", NULL);

	/* add watch to bus for pipeline events */
	GstBus *bus = gst_pipeline_get_bus(GST_PIPELINE(pipe));
	gst_bus_add_watch(bus, bus_watch, NULL);
	gst_object_unref(bus);

	/* set the audio sink */
	GstElement *sink = make_audio_sink();
	g_assert(sink);
	g_object_set(pipe, "audio-sink", sink, "video-sink", NULL, "vis-plugin", NULL, NULL);

	return pipe;
}

void init_audio()
{
	playbin_pipe = create_pipeline();
	tags_ = gst_tag_list_new();
}

static void halt_pipeline()
{
	GstStateChangeReturn scr;

	/* stop the pipeline */
	scr = gst_element_set_state(playbin_pipe, GST_STATE_NULL);
#if 0
	/* blocking on state change probably isn't a good idea */
	if (scr == GST_STATE_CHANGE_ASYNC) {
		GstState state;
		do {
			scr = gst_element_get_state(
					playbin_pipe, &state, NULL, GST_CLOCK_TIME_NONE);
		} while (scr == GST_STATE_CHANGE_ASYNC);
	}
#else
	/* i'm not sure that failure matters... */
	if (scr == GST_STATE_CHANGE_ASYNC)
		g_printerr("stopping the pipeline returned async state\n");
	if (GST_STATE(playbin_pipe) > GST_STATE_READY)
		g_printerr("playbin pipeline state may be too active for track change\n");
#endif
}

void play_audio()
{
	/* stop current track */
	halt_pipeline();

	/* kick off the new one */
	gchar const *uri = g_list_nth_data(music_uri_list, current_track);
	if (uri) {
		/* set the new track */
		g_object_set(playbin_pipe, "uri", uri, NULL);
		gst_element_set_state(playbin_pipe, GST_STATE_PLAYING);
	} else {
		/* invalid track number */
		current_track = -1;
		g_object_set(playbin_pipe, "uri", NULL, NULL);
		g_printerr("Track number out of range\n");
	}
}

void set_track(gint number)
{
	gint trackc = g_list_length(music_uri_list);
	if (number >= trackc) number = 0;
	else if (number < 0) number = trackc - 1;
	current_track = number;
	gst_tag_list_free(tags_);
	tags_ = gst_tag_list_new();
	play_audio();
}

void next_track()
{
	gint next;
	if (shuffle_) {
		next = g_random_int_range(0, g_list_length(music_uri_list));
	} else {
		next = current_track + 1;
	}
	g_debug("setting track number %d", next);
	set_track(next);
}

void prev_track()
{
	set_track(current_track - 1);
}

void delete_track()
{
	halt_pipeline();

	/* "steal" pointer */
	int track = current_track;
	gchar *uri = g_list_nth_data(music_uri_list, track);
	music_uri_list = g_list_delete_link(
			music_uri_list, g_list_nth(music_uri_list, track));

	GError *error;
	GFile *file = g_file_new_for_uri(uri);
	if (g_file_trash(file, NULL, &error)) {
		// d'oh
		//g_error_free(error);
	}

	g_free(uri);

	play_audio();
}

void play_pause()
{
	GstState target;
	if (GST_STATE(playbin_pipe) == GST_STATE_PLAYING)
		target = GST_STATE_PAUSED;
	else
		target = GST_STATE_PLAYING;
	gst_element_set_state(playbin_pipe, target);
}
