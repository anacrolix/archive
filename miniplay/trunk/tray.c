#include "miniplay.h"

GtkWidget *popup_menu = NULL;
GtkStatusIcon *status_icon = NULL;

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
		g_debug("selected: %s\n", filename);
		set_music_directory(filename);
		g_free(filename);
	}

	gtk_widget_destroy(dialog);
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
create_status_icon()
{
	g_assert(!status_icon);

	status_icon = gtk_status_icon_new_from_stock(GTK_STOCK_ADD);

	gtk_status_icon_set_visible(status_icon, TRUE);
	g_debug("embedded: %s\n",
			gtk_status_icon_is_embedded(status_icon) ? "yes" : "no");

	gtk_status_icon_set_tooltip(status_icon, "Miniplay");

	g_signal_connect(G_OBJECT(status_icon), "popup-menu",
			G_CALLBACK(popup_menu_handler), NULL);
	/* status icon click implementation */
	//g_signal_connect(G_OBJECT(status_icon), "activate",
	//		G_CALLBACK(activate_callback), NULL);
}

static void
create_popup_menu()
{
	g_assert(!popup_menu);

	popup_menu = gtk_menu_new();

	GtkWidget *menu_item;

	menu_item = gtk_menu_item_new_with_label("Music Directory...");
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(on_select_music), NULL);

	menu_item = gtk_menu_item_new_with_label("Quit");
	gtk_menu_append(popup_menu, menu_item);
	g_signal_connect(G_OBJECT(menu_item), "activate",
			G_CALLBACK(gtk_main_quit), NULL);
}

void init_tray()
{
	create_status_icon();
	create_popup_menu();
}
