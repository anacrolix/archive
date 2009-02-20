#include "miniplay.h"

gchar const mp_app_name[] = "Miniplayer";

gint main(gint argc, gchar *argv[])
{
	/* initialize libraries */
	gtk_init(&argc, &argv);
	gst_init(&argc, &argv);
	notify_init(mp_app_name);
	g_set_prgname(mp_app_name);

	/* parse options */
	gchar *conf_path = g_build_filename(
			g_get_home_dir(), ".miniplay", NULL);

	/* initialize our modules */
	if (!mp_conf_init(conf_path)) goto uninit_libs;
	init_audio();
	init_tray();
	mp_notify_init();

	/* prepare initial events */
	if (mp_conf_has_music_dir())
		set_music_directory(mp_conf_get_music_dir());
	else
		g_idle_add(select_music, NULL);

	/* loop */
	gtk_main();

	/* cleanup our modules */
	mp_conf_save();
	g_free(conf_path);

	/* uninit libraries */
uninit_libs:
	notify_uninit();

	return 0;
}
