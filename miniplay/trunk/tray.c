#include "miniplay.h"

GtkWidget *popup_menu = NULL;
GtkStatusIcon *status_icon = NULL;


void pause_icon(void)
{
	g_debug("Changing to pause icon..");
	gtk_status_icon_set_from_file (status_icon, "pause-icon.svg");
}

void play_icon(void)
{
	g_debug("Changing to play icon..");
	gtk_status_icon_set_from_file(status_icon, "play-icon.svg");
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
on_select_music(GtkMenuItem *menu_item, gpointer data)
{
	GtkWidget *dialog = gtk_file_chooser_dialog_new(
			"Select music directory", NULL,
			GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
			GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
			GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
			NULL);

	/* choose a default music directory and apply it */
	gchar const *music_dirs[] = {"Music", "music"};
	gchar *default_path;

	for (gchar const **md = music_dirs; *md; md++) {
		/* get a full path */
		if (g_path_is_absolute(*md))
			default_path = g_strdup(*md);
		else
			default_path = g_build_filename(g_get_home_dir(), *md, NULL);

		/* if it's a directory we're done */
		if (g_file_test(default_path, G_FILE_TEST_IS_DIR))
			break;
		g_free(default_path);
	}

	/* set the default music folder */
	gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER(dialog), default_path);
 	g_free(default_path);

	if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
		/* retrieve the selected folder before destroying the dialog */
		gchar *filename = gtk_file_chooser_get_filename(
				GTK_FILE_CHOOSER(dialog));
		gtk_widget_destroy(dialog);
		g_debug("selected: %s", filename);
		/* parse the music folder */
		set_music_directory(filename);
		g_free(filename);
	} else {
		/* blow this mofo outta the sky */
		gtk_widget_destroy(dialog);
	}
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
	
	gtk_status_icon_set_from_file (status_icon, "pause-icon.svg");

	gtk_status_icon_set_tooltip(status_icon, "Miniplay");

	g_signal_connect(G_OBJECT(status_icon), "popup-menu",
			G_CALLBACK(popup_menu_handler), NULL);

	/* status icon click implementation */
	g_signal_connect(G_OBJECT(status_icon), "activate",
			G_CALLBACK(activate_handler), NULL);

	gtk_status_icon_set_visible(status_icon, TRUE);
	g_debug("embedded: %s",
			gtk_status_icon_is_embedded(status_icon) ? "yes" : "no");
}

static void
on_toggle_shuffle(GtkCheckMenuItem *cmi, gpointer user)
{
	set_shuffle(gtk_check_menu_item_get_active(cmi));
}

static void
create_popup_menu()
{
	g_assert(!popup_menu);

	popup_menu = gtk_menu_new();

	GtkWidget *menu_item;

	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_MEDIA_PREVIOUS, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_prev_track), NULL);

	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_MEDIA_NEXT, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_next_track), NULL);

	menu_item = gtk_separator_menu_item_new();
	gtk_menu_append(popup_menu, menu_item);

	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_DELETE, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_delete_track), NULL);

	menu_item = gtk_separator_menu_item_new();
	gtk_menu_append(popup_menu, menu_item);

	menu_item = gtk_image_menu_item_new_with_label("Select music...");
	gtk_image_menu_item_set_image(
			GTK_IMAGE_MENU_ITEM(menu_item),
			gtk_image_new_from_stock(GTK_STOCK_OPEN, GTK_ICON_SIZE_MENU));
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_select_music), NULL);
	gtk_menu_item_activate(GTK_MENU_ITEM(menu_item));

	menu_item = gtk_check_menu_item_new_with_label("Shuffle");
	gtk_check_menu_item_set_active(GTK_CHECK_MENU_ITEM(menu_item), TRUE);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "toggled",
			G_CALLBACK(on_toggle_shuffle), NULL);
	gtk_check_menu_item_toggled(GTK_CHECK_MENU_ITEM(menu_item));

	menu_item = gtk_separator_menu_item_new();
	gtk_menu_append(popup_menu, menu_item);

	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_QUIT, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(gtk_main_quit), NULL);
}

void init_tray()
{
	create_status_icon();
	create_popup_menu();
}
