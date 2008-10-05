#include <assert.h>
#include <curses.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <gst/gst.h>
#include <libgnomevfs/gnome-vfs.h>

#define E9 1000000000LL

struct gst_data {
	GMainLoop *loop;
	gchar *uri;
	GstTagList *tags;
	GstElement *pipe;
	gchar *sink;
};

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
		GError *error;
		gst_message_parse_error(message, &error, NULL);
		g_printerr("%s: %s\n", msgtype, error->message);
		g_error_free(error);
		//g_main_loop_quit(data->main_loop);
		g_printerr("\n");
		return FALSE;
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
	g_return_val_if_fail(data->pipe, FALSE);
	
	gpointer retval = FALSE;
	
	/* choose and set an audio sink */
	gchar const *sink_factories[] = {
		"gconfaudiosink", "autoaudiosink", "alsasink", NULL};
	gchar const **sf_name;
	GstElement *sink;	
	for (sf_name = sink_factories; *sf_name && !sink; sf_name++);
		sink = gst_element_factory_make(*sf_name, NULL);
	if (!sink) {
		g_warn_if_reached();
		goto fail_sink;
	}
	data->sink = g_strdup(*sf_name);
	g_object_set(data->pipe, "audio-sink", sink, "video-sink", NULL, NULL);

	data->loop = g_main_loop_new(NULL, FALSE);

	/* watch for pipeline events */
	GstBus *bus = gst_pipeline_get_bus(GST_PIPELINE(data->pipe));
	gst_bus_add_watch(bus, bus_watch, data);
	gst_object_unref(bus);

	g_main_loop_run(data->loop);
	retval = (gpointer)TRUE;
	
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

void print_song(
	struct gst_data *data, WINDOW *win, int rows, int cols)
{
	/* print audio sink name */
	mvwprintw(win, 0, 0, "audio-sink: %s", data->sink);
	wclrtoeol(win);

	wmove(win, rows / 2 - 3, 0);

	/* print state */
	GstState state;
	gst_element_get_state(
		data->pipe, &state, NULL, GST_CLOCK_TIME_NONE);
	char *s;
	switch (state) {
		case GST_STATE_PAUSED: s = "paused"; break;
		case GST_STATE_PLAYING: s = "playing"; break;
		default: s = NULL;
	}
	print_song_line(win, cols, "%s", s);
	
	/* print uri */
	print_song_line(win, cols, "%s", data->uri);

	/* print song tags */
	gchar *artist = NULL, *album = NULL, *title = NULL;
	gst_tag_list_get_string(data->tags, GST_TAG_ARTIST, &artist);
	gst_tag_list_get_string(data->tags, GST_TAG_ALBUM, &album);
	gst_tag_list_get_string(data->tags, GST_TAG_TITLE, &title);
	print_song_line(win, cols, "%s / %s / %s", artist, album, title);
	g_free(artist); g_free(album); g_free(title);

	/* print song position/duration */
	GstFormat format = GST_FORMAT_TIME;
	gint64 position, duration;
	gst_element_query_position(data->pipe, &format, &position);
	gst_element_query_duration(data->pipe, &format, &duration);
	print_song_line(
		win, cols, "%lld:%02lld / %lld:%02lld",
		position / (60*E9), position / E9 % 60,
		duration / (60*E9), duration / E9 % 60);

	wrefresh(win);
}

void main_menu(struct gst_data *data)
{
	/* create play window with room for stdscr box */
	int playwin_rows = LINES - 2;
	int playwin_cols = COLS - 2;
	WINDOW *playwin = newwin(playwin_rows, playwin_cols, 1, 1);

	print_song(data, playwin, playwin_rows, playwin_cols);

	noecho();
	halfdelay(1);
	while (TRUE) {
		int ch = getch();
		switch (ch) {
		case ' ': {
			GstState state;
			gst_element_get_state(
				data->pipe, &state, NULL, GST_CLOCK_TIME_NONE);
			state = (state == GST_STATE_PAUSED) ? GST_STATE_PLAYING : GST_STATE_PAUSED;
			gst_element_set_state(data->pipe, state);
			break;
		}
		case 'q':
			goto quit;
		/* TODO: use up down keys to manipulate volume */
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
	};
	
	g_printerr("%s\n", data.uri);

	/* start the gst thread */
	GThread *gst_thread = g_thread_create(
		audio_thread_func, &data, TRUE, NULL);

	/* initialize curses */
	initscr();

	box(stdscr, ACS_VLINE, ACS_HLINE);
	curs_set(0);
	intro_screen();

	g_object_set(data.pipe, "uri", data.uri, NULL);
	gst_element_set_state(data.pipe, GST_STATE_PAUSED);
	main_menu(&data);

	endwin();
	g_main_loop_quit(data.loop);
	g_thread_join(gst_thread);
	
	g_free(data.uri);
	gst_tag_list_free(data.tags);
	
	return EXIT_SUCCESS;
}
