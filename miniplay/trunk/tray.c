#include "miniplay.h"

GtkWidget *popup_menu = NULL;
GtkStatusIcon *status_icon = NULL;

void blink_tray(gboolean blink)
{
	gtk_status_icon_set_blinking(status_icon, blink);
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
on_select_music(GtkMenuItem *menu_item, gpointer data)
{
	GtkWidget *dialog = gtk_file_chooser_dialog_new(
			"Select music directory", NULL,
			GTK_FILE_CHOOSER_ACTION_OPEN,
			GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
			GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
			NULL);
	gtk_file_chooser_set_action(
			GTK_FILE_CHOOSER(dialog),
			GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER);

	if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
		gchar *filename = gtk_file_chooser_get_filename(
				GTK_FILE_CHOOSER(dialog));
		gtk_widget_destroy(dialog);
		g_debug("selected: %s\n", filename);
		set_music_directory(filename);
		g_free(filename);
	} else {
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

	status_icon = gtk_status_icon_new_from_stock(GTK_STOCK_CDROM);

	gtk_status_icon_set_visible(status_icon, TRUE);
	g_debug("embedded: %s\n",
			gtk_status_icon_is_embedded(status_icon) ? "yes" : "no");

	gtk_status_icon_set_tooltip(status_icon, "Miniplay");

	g_signal_connect(G_OBJECT(status_icon), "popup-menu",
			G_CALLBACK(popup_menu_handler), NULL);

	/* status icon click implementation */
	g_signal_connect(G_OBJECT(status_icon), "activate",
			G_CALLBACK(activate_handler), NULL);
}

static void
create_popup_menu()
{
	g_assert(!popup_menu);

	popup_menu = gtk_menu_new();

	GtkWidget *menu_item;

	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_MEDIA_NEXT, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_next_track), NULL);

	menu_item = gtk_image_menu_item_new_from_stock(
			GTK_STOCK_MEDIA_PREVIOUS, NULL);
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_prev_track), NULL);

	menu_item = gtk_image_menu_item_new_with_label("Music Directory...");
	gtk_image_menu_item_set_image(
			GTK_IMAGE_MENU_ITEM(menu_item),
			gtk_image_new_from_stock(GTK_STOCK_OPEN, GTK_ICON_SIZE_MENU));
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_select_music), NULL);

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
