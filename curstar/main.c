#include <curses.h>
#include <string.h>
#include <unistd.h>
#include <gst/gst.h>

struct gst_data {
	GMainLoop *loop;
	gchar *uri;
	GstElement *pipe;
};

gboolean bus_watch(
	GstBus *bus, GstMessage *message, gpointer _data)
{
	struct gst_data *data = _data;
	if (GST_MESSAGE_TYPE(message) == GST_MESSAGE_ERROR) {
		gchar const *msgtype = GST_MESSAGE_TYPE_NAME(message);
		GError *error;
		gst_message_parse_error(message, &error, NULL);
		g_print("%s: %s\n", msgtype, error->message);
		g_error_free(error);
		//g_main_loop_quit(data->main_loop);
		return FALSE;
	}
	return TRUE;
}

gpointer audio_thread_func(gpointer _data)
{
	struct gst_data *data = _data;

	/* create the playbin pipeline */
	data->pipe = gst_element_factory_make("playbin", NULL);

	data->loop = g_main_loop_new(NULL, FALSE);

	/* watch for pipeline events */
	GstBus *bus = gst_pipeline_get_bus(data->pipe);
	gst_bus_add_watch(bus, bus_watch, data->loop);
	gst_object_unref(bus);

	g_main_loop_run(data->loop);

	/* stop and destroy the pipeline */
	gst_element_set_state(data->pipe, GST_STATE_NULL);
	gst_object_unref(data->pipe);

	return (gpointer)TRUE;
}

void print_song(struct gst_data *data)
{
	GstState state;
	gst_element_get_state(
		data->pipe, &state, NULL, GST_CLOCK_TIME_NONE);
	char const
		playing[] = "Playing",
		paused[] = "Paused",
		*current = NULL;
	switch (state) {
		case GST_STATE_PAUSED: current = paused; break;
		case GST_STATE_PLAYING: current = playing; break;
		default: break;
	}
	mvprintw(LINES/2-1, (COLS-strlen(current))/2, "%s", current);
	mvprintw(LINES/2, (COLS-strlen(data->uri))/2, "%s", data->uri);
}

void main_menu(struct gst_data *data)
{
	clear();
	box(stdscr, ACS_VLINE, ACS_HLINE);
	noecho();
	cbreak();
	print_song(data);
	int ch;
	while ((ch = getch()) != 'q') {
		switch (ch) {
		case ' ': {
			GstState state;
			gst_element_get_state(
				data->pipe, &state, NULL, GST_CLOCK_TIME_NONE);
			state = (state == GST_STATE_PAUSED) ? GST_STATE_PLAYING : GST_STATE_PAUSED;
			gst_element_set_state(data->pipe, state);
			print_song(data);
			break;
		}
		default:
			break;
		}
	}
}

void intro_screen()
{
	box(stdscr, ACS_VLINE, ACS_HLINE);
	char const greeting[] = "Welcome to Curstar!";
	mvprintw(LINES / 2, (COLS - strlen(greeting))/2, "%s", greeting);
	refresh();
	sleep(1);
}

int main(int argc, char *argv[])
{
	/* initialize gstreamer */
	gst_init(&argc, &argv);

	if (argc != 2) {
		/* TODO: will argv[1] work if gstreamer is passed args? */
		fprintf(stderr, "Usage: %s <AUDIO_FILE>\n", argv[0]);
		return EXIT_FAILURE;
	}

	/* shares variables between gst and curses threads */
	struct gst_data data = {
		.uri = argv[1],
		.loop = NULL,
		.pipe = NULL,
	};

	/* start the gst thread */
	GThread *gst_thread = g_thread_create(
		audio_thread_func, &data, TRUE, NULL);

	/* initialize curses */
	initscr();

	intro_screen();

	g_object_set(data.pipe, "uri", data.uri, NULL);
	gst_element_set_state(data.pipe, GST_STATE_PAUSED);
	main_menu(&data);

	endwin();
	g_main_loop_quit(data.loop);
	g_thread_join(gst_thread);
	return EXIT_SUCCESS;
}
