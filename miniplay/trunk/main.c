#include "miniplay.h"

gint main(gint argc, gchar *argv[])
{
	gtk_init(&argc, &argv);
	gst_init(&argc, &argv);
	init_audio();
	init_tray();
	gtk_main();
	return 0;
}
