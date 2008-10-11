#include "audio.h"
#include <gst/gst.h>

GstElement *playbin_pipe = NULL;
GList *music_uri_list = NULL;
gint current_track = -1;
GstState desired_state;

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

#if 0
static gboolean
wait_for_state(GstState state)
{
	GstStateChangeReturn sc_ret;
	sc_ret = gst_element_set_state(playbin_pipe, state);
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
#endif

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
	desired_state = GST_STATE_NULL;
	g_assert(gst_element_set_state(playbin_pipe, GST_STATE_NULL) == GST_STATE_CHANGE_SUCCESS);

	free_music_list();
	music_uri_list = list;

	if (g_list_length(music_uri_list) > 0) {
		current_track = 0;
		g_object_set(playbin_pipe, "uri", g_list_nth_data(music_uri_list, 0), NULL);
		desired_state = GST_STATE_PLAYING;
		gst_element_set_state(playbin_pipe, GST_STATE_PLAYING);
	} else {
		current_track = -1;
		g_object_set(playbin_pipe, "uri", NULL, NULL);
	}
}

/** receive and process messages on the playbin bus */
static gboolean
bus_watch(GstBus *bus, GstMessage *msg, gpointer data)
{
#if 0
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
#endif
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
	g_object_set(pipe, "audio-sink", sink, "video-sink", NULL, NULL);

	return pipe;
}

void init_audio()
{
	playbin_pipe = create_pipeline();
}
