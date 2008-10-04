#include <curses.h>
#include <unistd.h>
#include <gst/gst.h>

struct gst_data {
	GMainLoop *main_loop;
	gchar *source_uri;
	GstElement *play_pipeline;
};

gboolean bus_watch_callback(
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

gpointer gst_stuff(gpointer _data)
{
	struct gst_data *data = _data;
	GstBus *bus;
	data->main_loop = g_main_loop_new(NULL, FALSE);
	data->play_pipeline = gst_element_factory_make("playbin", NULL);
	g_object_set(data->play_pipeline, "uri", data->source_uri, NULL);
	bus = gst_pipeline_get_bus(data->play_pipeline);
	gst_bus_add_watch(bus, bus_watch_callback, data->main_loop);
	gst_object_unref(bus);

	g_main_loop_run(data->main_loop);

	gst_element_set_state(data->play_pipeline, GST_STATE_NULL);
	gst_object_unref(data->play_pipeline);
	return NULL;
}

int main(int argc, char *argv[])
{
	GThread *gst_thread;

	gst_init(&argc, &argv);

	if (argc != 2) {
		fprintf(stderr, "Usage: %s <AUDIO_FILE>\n", argv[0]);
		return EXIT_FAILURE;
	}

	struct gst_data data = {
		.source_uri = argv[1],
	};

	gst_thread = g_thread_create(gst_stuff, &data, TRUE, NULL);

	initscr();
	box(stdscr, ACS_VLINE, ACS_HLINE);
	mvprintw(11, 30, "%s", "Welcome to Curstar!");
	refresh();
	sleep(1);

	clear();
	box(stdscr, ACS_VLINE, ACS_HLINE);
	mvprintw(11, 30, "Playing: %s", data.source_uri);
	refresh();
	gst_element_set_state(data.play_pipeline, GST_STATE_PAUSED);
	getch();

	endwin();
	g_main_loop_quit(data.main_loop);
	g_thread_join(gst_thread);
	return EXIT_SUCCESS;
}
