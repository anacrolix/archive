#include <stdlib.h>
#include <gst/gst.h>

static void havetype_callback(
	GstElement *typefind, guint prob,
	GstCaps *caps, GstCaps **data)
{
	*data = gst_caps_copy(caps);
}

static void typefind_file(gchar const *filename, GHashTable *types)
{
	/* pipeline: filesrc -> typefind */
	GstElement *pipeline = gst_pipeline_new (NULL);

	GstElement *source = gst_element_factory_make ("filesrc", NULL);
	g_assert(source);
	GstElement *typefind = gst_element_factory_make ("typefind", NULL);
	g_assert(typefind);

	gst_bin_add_many(GST_BIN(pipeline), source, typefind, NULL);
	gst_element_link_many(source, typefind, NULL);

	GstCaps *caps;
	/* have-type handler copies found caps into the user param */
	g_signal_connect(G_OBJECT(typefind), "have-type", G_CALLBACK(havetype_callback), &caps);

	g_object_set(source, "location", filename, NULL);

	/* this will execute until error or have-type signal is sent */
	gst_element_set_state(pipeline, GST_STATE_PAUSED);

	GstStateChangeReturn sc_ret;
	sc_ret = gst_element_get_state(pipeline, NULL, NULL, -1);

	switch (sc_ret) {
	case GST_STATE_CHANGE_FAILURE: {
#if 0
		GstBus *bus = gst_pipeline_get_bus(GST_PIPELINE(pipeline));
		GstMessage *msg = gst_bus_poll(bus, GST_MESSAGE_ERROR, 0);
		gst_object_unref(bus);

		if (msg) {
			GError *err;
			gst_message_parse_error(msg, &err, NULL);
			g_printerr("%s: Failed to retrieve type: %s\n", filename, err->message);
			g_error_free(err);
			gst_message_unref(msg);
		} else {
			g_printerr("%s: Unknown error\n", filename);
		}
#else
		gpointer value = g_hash_table_lookup(types, "UNKNOWN");
		value += 1;
		g_hash_table_insert(types, "UNKNOWN", value);
#endif
		break;
	}
	case GST_STATE_CHANGE_SUCCESS: {
		guint capsize = gst_caps_get_size(caps);
		g_assert(capsize == 1);
		GstStructure *capst = gst_caps_get_structure(caps, 0);
		gchar const *capname = gst_structure_get_name(capst);
		gpointer value = g_hash_table_lookup(types, capname);
		value += 1;
		g_hash_table_insert(types, (gpointer)capname, value);
		break;
	}
	default:
		g_assert_not_reached();
	}

	gst_element_set_state(pipeline, GST_STATE_NULL);
	gst_object_unref(pipeline);
}

static void typefind_path_recurse(gchar const *path, GHashTable *types)
{
	GDir *dir;
	if ((dir = g_dir_open(path, 0, NULL))) {
		gchar const *entry;
		while ((entry = g_dir_read_name(dir))) {
			gchar *newpath;
			newpath = g_strconcat(path, G_DIR_SEPARATOR_S, entry, NULL);
			typefind_path_recurse(newpath, types);
			g_free(newpath);
		}
		g_dir_close (dir);
	} else {
		typefind_file(path, types);
	}
}

static void print_type_summary(
	gpointer key, gpointer value, gpointer user)
{
	printf("%7lu %s\n", (long unsigned)value, (gchar *)key);
}

int main(int argc, char *argv[])
{
	if (argc < 2) {
		printf("Usage: %s PATHS...\n", argv[0]);
		return EXIT_FAILURE;
	}

	gst_init(&argc, &argv);
	GHashTable *types = g_hash_table_new(g_str_hash, g_str_equal);
	char **path = &argv[1];
	do {
		typefind_path_recurse(*path, types);
	} while (*++path);
	g_hash_table_foreach(types, print_type_summary, NULL);
	g_hash_table_destroy(types);

	return EXIT_SUCCESS;
}
