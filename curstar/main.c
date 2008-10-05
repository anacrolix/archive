/*
A ncurses/gstreamer single-file audio player.

Developers: Eruanno (October 2008)
Testing: Winter, Erikina

Required libs: ncurses, glibc, gnomevfs, gstreamer
Gst-plugins: "playbin" element from gstreamer-plugins-base

The initial thread handles ncurses. A spawned thread handles the the pipeline(s)
and a glib mainloop. Stderr is directed to 'errlog' in the working directory.

A single URI or local file path is passed in as a parameter and played once.

After the intro screen, spacebar toggles play/pause, 'q' quits, and up and down
arrow keys change the volume.
*/

#include <assert.h>
#include <curses.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <gst/gst.h>
#include <libgnomevfs/gnome-vfs.h>

#define E9 1000000000LL

typedef enum { UP, DOWN, QUERY } VolumeChange;

struct gst_data {
	GMainLoop *loop;
	gchar *uri;
	GstTagList *tags;
	GstElement *pipe;
	gchar *sink;
	GError *error;
	/* cond & mutex protect init */
	gboolean init;
	GCond *cond;
	GMutex *mutex;
};

void gst_data_set_init(struct gst_data *data)
{
	g_mutex_lock(data->mutex);
	data->init = TRUE;
	g_cond_broadcast(data->cond);
	g_mutex_unlock(data->mutex);
}

void tags_foreach(
	GstTagList const *list, gchar const *tag, gpointer user)
{
	g_printerr("%s\n", gst_tag_get_nick(tag));
}

gboolean bus_watch(
	GstBus *bus, GstMessage *message, gpointer _data)
{
	struct gst_data *data = _data;
	gchar const *msgtype = GST_MESSAGE_TYPE_NAME(message);

	switch (GST_MESSAGE_TYPE(message)) {
	case GST_MESSAGE_ERROR: {
		/* print the error */
		if (data->error) g_error_free(data->error);
		gst_message_parse_error(message, &data->error, NULL);
		g_printerr("%s: %s\n", msgtype, data->error->message);
		break;
	}
	case GST_MESSAGE_TAG: {
		/* merge in new tags */
		GstTagList *tag_list;
		gst_message_parse_tag(message, &tag_list);
		gst_tag_list_insert(data->tags, tag_list, GST_TAG_MERGE_REPLACE);
		//gst_tag_list_foreach(tag_list, tags_foreach, NULL);
		gst_tag_list_free(tag_list);
		break;
	}
	default:
		break;
	}
	return TRUE;
}

gpointer audio_thread_func(gpointer _data)
{
	struct gst_data *data = _data;

	/* create the playbin pipeline */
	data->pipe = gst_element_factory_make("playbin", NULL);
	if (!data->pipe) {
		gst_data_set_init(data);
		g_warn_if_reached();
		return FALSE;
	}
		
	gpointer retval = FALSE;
	
	/* choose and set an audio sink */
	gchar const *sink_factories[] = {
		"gconfaudiosink", "autoaudiosink", "alsasink", NULL};
	gchar const **sf_name;
	GstElement *sink;	
	for (sf_name = sink_factories; *sf_name && !sink; sf_name++);
		sink = gst_element_factory_make(*sf_name, NULL);
	if (!sink) {
		gst_data_set_init(data);
		g_warn_if_reached();
		goto fail_sink;
	}
	data->sink = g_strdup(*sf_name);
	g_object_set(data->pipe, "audio-sink", sink, "video-sink", NULL, NULL);

	gst_data_set_init(data); /* let the main thread proceed */
	data->loop = g_main_loop_new(NULL, FALSE);

	/* watch for pipeline events */
	GstBus *bus = gst_pipeline_get_bus(GST_PIPELINE(data->pipe));
	gst_bus_add_watch(bus, bus_watch, data);
	gst_object_unref(bus);

	g_main_loop_run(data->loop);
	retval = (gpointer)TRUE;
	
	g_free(data->sink);
	
	/* stop and destroy the pipeline */
fail_sink:
	gst_element_set_state(data->pipe, GST_STATE_NULL);
	gst_object_unref(data->pipe);

	return retval;
}

static void print_song_line(
	WINDOW *win, int cols, char *fmt, ...)
{
	char line[cols + 1];
	memset(line, ' ', cols);
	line[cols] = '\0';

	va_list ap;
	va_start(ap, fmt);
	char *s = g_strdup_vprintf(fmt, ap);
	va_end(ap);

	int n = strlen(s);
	if (n < cols) {
		strncpy(&line[(cols - n) / 2], s, n);
		waddstr(win, line);
	} else {
		waddstr(win, s);
	}
	waddch(win, '\n');

	g_free(s);
}

static char const *gst_state_to_string(GstState state)
{
	switch (state) {
		case GST_STATE_NULL: return "Initializing";
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

/**
@return: Volume as a percentage of maximum
*/
gdouble change_volume(GstElement *playbin, VolumeChange vc)
{
	gdouble volume;
	g_object_get(playbin, "volume", &volume, NULL);
	switch (vc) {
	case UP:
		volume += 0.1;
		if (volume > 1.0) volume = 1.0;
		break;
	case DOWN: 
		volume -= 0.1; 
		if (volume < 0.0) volume = 0.0;
		break;
	case QUERY:
		goto done;
	}
	g_object_set(playbin, "volume", volume, NULL);
done:
	return 100 * volume;
}

void print_song(
	struct gst_data *data, WINDOW *win, int rows, int cols)
{
	/* print audio sink name */
	mvwprintw(win, 0, 0, "audio-sink: %s", data->sink);
	wclrtoeol(win);
	mvwprintw(win, 1, 0, "volume: %3.0f%%", change_volume(data->pipe, QUERY));
	wclrtoeol(win);

	wmove(win, rows / 2 - 3, 0);

	/* print state */
	GstState state = GST_STATE(data->pipe);
	GstState pending = GST_STATE_PENDING(data->pipe);
		
	if (pending != GST_STATE_VOID_PENDING) {
		g_assert(state != pending);
		print_song_line(
			win, cols, "%s...",
			gst_state_transition_to_string(GST_STATE_TRANSITION(state, pending)));
	} else {
		print_song_line(win, cols, "%s", gst_state_to_string(state));
	}
	
	/* print uri */
	char *intelligible = gnome_vfs_unescape_string_for_display(data->uri);
	print_song_line(win, cols, "%s", intelligible);
	g_free(intelligible);

	/* print song tags */
	gchar *artist = NULL, *album = NULL, *title = NULL;
	gst_tag_list_get_string(data->tags, GST_TAG_ARTIST, &artist);
	gst_tag_list_get_string(data->tags, GST_TAG_ALBUM, &album);
	gst_tag_list_get_string(data->tags, GST_TAG_TITLE, &title);
	print_song_line(win, cols, "%s / %s / %s", artist, album, title);
	g_free(artist); g_free(album); g_free(title);

	/* print song position/duration */
	GstFormat format = GST_FORMAT_TIME;
	gint64 position = 0, duration = 0;
	if (gst_element_query_position(data->pipe, &format, &position) &&
		format == GST_FORMAT_TIME &&
		gst_element_query_duration(data->pipe, &format, &duration) &&
		format == GST_FORMAT_TIME)
	{
		print_song_line(
			win, cols, "%lld:%02lld / %lld:%02lld",
			position / (60*E9), position / E9 % 60,
			duration / (60*E9), duration / E9 % 60);
	} else {
		print_song_line(win, cols, "ERROR QUERYING POSITION/DURATION");
	}

	wrefresh(win);
}

void main_menu(struct gst_data *data)
{
	/* create play window with room for stdscr box */
	int playwin_rows = LINES - 2;
	int playwin_cols = COLS - 2;
	WINDOW *playwin = newwin(playwin_rows, playwin_cols, 1, 1);

	print_song(data, playwin, playwin_rows, playwin_cols);

	assert(keypad(playwin, TRUE) == OK);
	noecho();
	halfdelay(1);
	while (TRUE) {
		int ch = wgetch(playwin);
		switch (ch) {
		case ' ': {
			GstState state;
			gst_element_get_state(
				data->pipe, &state, NULL, 0LL);
			state = (state == GST_STATE_PAUSED) ? GST_STATE_PLAYING : GST_STATE_PAUSED;
			gst_element_set_state(data->pipe, state);
			break;
		}
		case 'q':
			goto quit;
		case KEY_UP:
			change_volume(data->pipe, UP);
			break;			
		case KEY_DOWN: {
			change_volume(data->pipe, DOWN);
			break;
		}
		default:
			break;
		}
		print_song(data, playwin, playwin_rows, playwin_cols);
	}
quit:
	delwin(playwin);
}

void intro_screen()
{
	char const greeting[] = "Welcome to Curstar!";
	mvprintw(LINES/2,(COLS-strlen(greeting))/2,"%s",greeting);
	refresh();
	sleep(1);
}

int main(int argc, char *argv[])
{
	/* redirect stderr so it doesn't shit all over the console */
	if (isatty(fileno(stderr)))
		assert(freopen("errlog", "w", stderr));		
	
	/* initialize gstreamer */
	gst_init(&argc, &argv);

	if (argc != 2) {
		/* TODO: will argv[1] work if gstreamer is passed args? */
		fprintf(stderr, "Usage: %s <URI>\n", argv[0]);
		return EXIT_FAILURE;
	}		

	/* shares variables between gst and curses threads */
	struct gst_data data = {
		.uri = gnome_vfs_make_uri_from_input(argv[1]),
		.loop = NULL,
		.pipe = NULL,
		.tags = gst_tag_list_new(),
		.mutex = g_mutex_new(),
		.cond = g_cond_new(),
		.error = NULL,
	};
	
	g_printerr("%s\n", data.uri);

	/* start the gst thread */
	GThread *gst_thread = g_thread_create(
		audio_thread_func, &data, TRUE, NULL);

	/* wait for thread to initialize */
	g_mutex_lock(data.mutex);
	while (!data.init)
		g_cond_wait(data.cond, data.mutex);
	g_mutex_unlock(data.mutex);

	g_object_set(data.pipe, "uri", data.uri, NULL);
	GstStateChangeReturn sc_ret = gst_element_set_state(
		data.pipe, GST_STATE_PAUSED);
	
	if (sc_ret == GST_STATE_CHANGE_FAILURE) {
		/* don't try this at home */
		while (!data.error) g_thread_yield();
		g_print("Invalid URI: %s\n", data.error->message);
		goto fail_audio;
	}

	/* initialize curses */
	initscr();

	box(stdscr, ACS_VLINE, ACS_HLINE);
	curs_set(0); /* this will break on unclean shutdown */
	intro_screen();

	main_menu(&data);

	endwin();

fail_audio:
	g_main_loop_quit(data.loop);
	g_thread_join(gst_thread);
	
	g_free(data.uri);
	gst_tag_list_free(data.tags);
	g_cond_free(data.cond);
	g_mutex_free(data.mutex);
	if (data.error) g_error_free(data.error);
	
	return EXIT_SUCCESS;
}

