#include "miniplay.h"

gchar const mp_app_name[] = "Miniplayer";

gint main(gint argc, gchar *argv[])
{
	gtk_init(&argc, &argv);
	gst_init(&argc, &argv);
	notify_init(mp_app_name);

	g_set_prgname(mp_app_name);
	init_audio();
	init_tray();
	mp_notify_init();

	select_music();
	connect_tray_signals();

	gtk_main();

	notify_uninit();

	return 0;
}
