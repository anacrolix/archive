#include "miniplay.h"

gchar const mp_app_name[] = "Miniplayer";

gint main(gint argc, gchar *argv[])
{
	/* initialize libraries */
	
	gtk_init(&argc, &argv);
	gst_init(&argc, &argv);
	notify_init(mp_app_name);

	g_set_prgname(mp_app_name);
	
	/* initialize our modules */
	
	init_audio();
	init_tray();
	mp_notify_init();
	
	g_idle_add(select_music, NULL);

	gtk_main();

	notify_uninit();

	return 0;
}
