#include "miniplay.h"

GtkWidget *popup_menu = NULL;
GtkStatusIcon *status_icon = NULL;

GtkStatusIcon *mp_get_status_icon()
{
	return status_icon;
}

void pause_icon(void)
{
	//g_debug("Changing to pause icon");
	//gtk_status_icon_set_from_file (status_icon, "pause-icon.svg");
	/* until nicer icons are found */
	gtk_status_icon_set_from_stock(status_icon, GTK_STOCK_MEDIA_PAUSE);
}

void play_icon(void)
{
	//g_debug("Changing to play icon");
	//gtk_status_icon_set_from_file(status_icon, "play-icon.svg");
	/* until nicer icons are found */
	gtk_status_icon_set_from_stock(status_icon, GTK_STOCK_MEDIA_PLAY);
}

static void
on_next_track(GtkMenuItem *menu_item, gpointer data)
{
	next_track();
}

static void
on_prev_track(GtkMenuItem *menu_item, gpointer data)
{
	prev_track();
}

static void
on_delete_track(GtkMenuItem *menu_item, gpointer data)
{
	delete_track();
}

static void
on_set_volume(GtkCheckMenuItem *menu_item, gpointer user)
{
	if (!gtk_check_menu_item_get_active(menu_item))
		return;

	gdouble *vol = user;
	g_debug("setting volume to %f", *vol);
	set_volume(*vol);
	mp_conf_set_volume(*vol);
}

gboolean select_music(gpointer data)
{
	static GStaticMutex mutex = G_STATIC_MUTEX_INIT;
	
	if (g_static_mutex_trylock(&mutex) == FALSE) {
		g_debug("select_music() already in use");
		return TRUE;
	}
	
	gtk_status_icon_set_blinking(status_icon, TRUE);

	GtkWidget *dialog = gtk_file_chooser_dialog_new(
			"Select music directory", NULL,
			GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
			GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
			GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
			NULL);

	/* set the default music folder */
	if (mp_conf_get_music_dir())
		gtk_file_chooser_set_filename(
				GTK_FILE_CHOOSER(dialog), mp_conf_get_music_dir());

	/* display selection dialog */
	g_debug("running select music dialog");
	gint response = gtk_dialog_run(GTK_DIALOG(dialog));
	g_debug("returned from select music dialog");

	gchar *filename = gtk_file_chooser_get_filename(
			GTK_FILE_CHOOSER(dialog));
	gtk_widget_destroy(dialog);
	g_debug("selected: %s", filename);

	if (response == GTK_RESPONSE_ACCEPT) {
		set_music_directory(filename);
		mp_conf_set_music_dir(filename);
	}

	g_free(filename);
	gtk_status_icon_set_blinking(status_icon, FALSE);
	
	g_static_mutex_unlock(&mutex);
	
	return FALSE;
}

static void
on_select_music(GtkMenuItem *menu_item, gpointer data)
{
	select_music(NULL);
}

static void
popup_menu_handler(
		GtkStatusIcon *status_icon, guint button,
		guint activate_time, gpointer user_data)
{
	gtk_widget_show_all(popup_menu);
	gtk_menu_popup(GTK_MENU(popup_menu), NULL, NULL,
			gtk_status_icon_position_menu, status_icon,
			button, activate_time);
}

static void
activate_handler(GtkStatusIcon *status_icon, gpointer user)
{
	play_pause();
}

static void
create_status_icon()
{
	g_assert(!status_icon);

	status_icon = gtk_status_icon_new();

	//gtk_status_icon_set_from_file(status_icon, "pause-icon.svg");
	gtk_status_icon_set_from_stock(status_icon, GTK_STOCK_MEDIA_PAUSE);

	gtk_status_icon_set_tooltip(status_icon, "Miniplay");
}

static void
on_toggle_shuffle(GtkCheckMenuItem *cmi, gpointer user)
{
	set_shuffle(gtk_check_menu_item_get_active(cmi));
}

/* this might be generalised further to load resources */
static GdkPixbuf *
load_pixbuf_from_file(gchar const *pc1, gchar const *pc2)
{
	gchar *path = g_build_filename(pc1, pc2, NULL);
	g_debug("trying to load pixbuf from %s", path);
	GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file(path, NULL);
	g_free(path);
	return pixbuf;
}

static void
on_select_about(GtkCheckMenuItem *cmi, gpointer user)
{
	gchar const *authors[] = {
		"Eruanno <anacrolix@gmail.com>",
		"Erikina <erikina@gmail.com>",
		NULL,
	};

	static GdkPixbuf *logo = NULL;
	for (int i = 0; !logo; i++) {
		gchar const *dir = g_get_system_data_dirs()[i];
		if (!dir) dir = "";

		logo = load_pixbuf_from_file(dir, "miniplay/play-icon.svg");

		if (!*dir) break;
	}

	gtk_show_about_dialog(NULL,
			"authors", authors,
			"version", PACKAGE_VERSION,
			"comments", "A parsimonious GTK+ audio player.",
			"logo", logo,
			NULL);
}

static GtkWidget *
new_volume_menu()
{
	/* volume radio menu item type */
	typedef struct {
		gchar const *label;
		gdouble value;
	} vrmi_t;
	static vrmi_t const VOL_OPTIONS[] = {
		{"Max", 1.00},
		{"80%", 0.80},
		{"60%", 0.60},
		{"40%", 0.40},
		{"20%", 0.20},
		{"Off", 0.00},
	};

	GtkWidget *menu = gtk_menu_new();

	GSList *group = NULL;
	GtkWidget *item;

	for (	vrmi_t const *vo = VOL_OPTIONS;
			vo < VOL_OPTIONS + sizeof(VOL_OPTIONS) / sizeof(vrmi_t);
			vo++) {
		item = gtk_radio_menu_item_new_with_label(group, vo->label);
		group = gtk_radio_menu_item_get_group(GTK_RADIO_MENU_ITEM(item));
		gtk_menu_append(menu, item);
		g_signal_connect(G_OBJECT(item), "toggled",
				G_CALLBACK(on_set_volume), (gpointer)&vo->value);
		if (mp_conf_get_volume() == vo->value)
			gtk_check_menu_item_set_active(GTK_CHECK_MENU_ITEM(item), TRUE);
	}

	return menu;
}

static void
create_popup_menu()
{
	g_assert(!popup_menu);

	popup_menu = gtk_menu_new();

	GtkWidget *menu_item; /* used for new menu items */

	/* previous track */
	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_MEDIA_PREVIOUS, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_prev_track), NULL);

	/* next track */
	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_MEDIA_NEXT, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_next_track), NULL);

	/* volume submenu */
	menu_item = gtk_menu_item_new_with_label("Volume");
	gtk_menu_append(popup_menu, menu_item);
	gtk_menu_item_set_submenu(GTK_MENU_ITEM(menu_item), new_volume_menu());

	/* separator */
	menu_item = gtk_separator_menu_item_new();
	gtk_menu_append(popup_menu, menu_item);

	/* delete track */
	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_DELETE, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_delete_track), NULL);

	/* separator */
	menu_item = gtk_separator_menu_item_new();
	gtk_menu_append(popup_menu, menu_item);

	/* select music directory */
	menu_item = gtk_image_menu_item_new_with_label("Select music...");
	gtk_image_menu_item_set_image(
			GTK_IMAGE_MENU_ITEM(menu_item),
			gtk_image_new_from_stock(GTK_STOCK_OPEN, GTK_ICON_SIZE_MENU));
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_select_music), NULL);

	/* shuffle checkbox */
	menu_item = gtk_check_menu_item_new_with_label("Shuffle");
	gtk_check_menu_item_set_active(GTK_CHECK_MENU_ITEM(menu_item), TRUE);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "toggled",
			G_CALLBACK(on_toggle_shuffle), NULL);
	gtk_check_menu_item_toggled(GTK_CHECK_MENU_ITEM(menu_item));

	/* separator */
	menu_item = gtk_separator_menu_item_new();
	gtk_menu_append(popup_menu, menu_item);

	/* about */
	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_ABOUT, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_select_about), NULL);

	/* quit */
	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_QUIT, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(gtk_main_quit), NULL);
}

void
connect_tray_signals()
{
	g_signal_connect(G_OBJECT(status_icon), "popup-menu",
			G_CALLBACK(popup_menu_handler), NULL);

	/* status icon click implementation */
	g_signal_connect(G_OBJECT(status_icon), "activate",
			G_CALLBACK(activate_handler), NULL);

	gtk_status_icon_set_visible(status_icon, TRUE);
	g_debug("embedded: %s",
			gtk_status_icon_is_embedded(status_icon) ? "yes" : "no");
}

void init_tray()
{
	create_status_icon();
	create_popup_menu();
	connect_tray_signals();
}
