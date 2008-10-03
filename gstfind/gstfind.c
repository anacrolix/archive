#include <stdlib.h>
#include <gst/gst.h>

static void havetype_callback(
	GstElement *typefind, guint prob,
	GstCaps *caps, GstCaps **data)
{
	*data = gst_caps_copy(caps);
}

static void typefind_file(gchar const *path)
{
	GstElement *pipeline = gst_pipeline_new (NULL);

	GstElement *source = gst_element_factory_make ("filesrc", NULL);
	GstElement *typefind = gst_element_factory_make ("typefind", NULL);

	gst_bin_add_many(GST_BIN(pipeline), source, typefind, NULL);
	gst_element_link_many(source, typefind, NULL);

	GstCaps *caps = NULL;
	g_signal_connect(G_OBJECT(typefind), "have-type", G_CALLBACK(havetype_callback), &caps);
	g_object_set(source, "location", path, NULL);

	gst_element_set_state(pipeline, GST_STATE_PAUSED);

	GstStateChangeReturn sc_ret;
	sc_ret = gst_element_get_state(pipeline, NULL, NULL, -1);

	switch (sc_ret) {
	case GST_STATE_CHANGE_FAILURE: {
		GstBus *bus = gst_pipeline_get_bus(GST_PIPELINE(pipeline));
		GstMessage *msg = gst_bus_poll(bus, GST_MESSAGE_ERROR, 0);
		gst_object_unref(bus);

		if (msg) {
			GError *err;
			gst_message_parse_error(msg, &err, NULL);
			g_printerr("%s: Failed to retrieve type: %s\n", path, err->message);
			g_error_free(err);
			gst_message_unref(msg);
		} else {
			g_printerr("%s: Unknown error\n", path);
		}
		break;
	}
	case GST_STATE_CHANGE_SUCCESS: {
		guint capsize = gst_caps_get_size(caps);
		g_assert(capsize == 1);
		GstStructure *capst = gst_caps_get_structure(caps, 0);
		printf("%s\n", gst_structure_get_name(capst));
		break;
	}
	default:
		g_assert_not_reached();
	}

	gst_element_set_state(pipeline, GST_STATE_NULL);
	gst_object_unref(pipeline);
}

static void typefind_path_recurse(gchar const *path)
{
	GDir *dir;
	if ((dir = g_dir_open(path, 0, NULL))) {
		gchar const *entry;
		while ((entry = g_dir_read_name(dir))) {
			gchar *newpath;
			newpath = g_strconcat(path, G_DIR_SEPARATOR_S, entry, NULL);
			typefind_path_recurse(newpath);
			g_free(newpath);
		}
		g_dir_close (dir);
	} else {
		typefind_file(path);
	}
}

int main(int argc, char *argv[])
{
	if (argc < 2) {
		printf("Usage: %s PATHS...\n", argv[0]);
		return EXIT_FAILURE;
	}

	gst_init(&argc, &argv);
	char **path = &argv[1];
	do {
		typefind_path_recurse(*path);
	 } while (*++path);

	return EXIT_SUCCESS;
}
