#include <gtk/gtk.h>

static GtkWidget *popup_menu = NULL;
static GtkStatusIcon *status_icon = NULL;

static void
on_blink_change(GtkStatusIcon *widget, gpointer data)
{
	gboolean blink = GPOINTER_TO_UINT(data);
	g_debug("Set blinking %s", (blink) ? "on" : "off");
	gtk_status_icon_set_blinking(GTK_STATUS_ICON(status_icon), blink);
}

static void
popup_menu_callback(
		GtkStatusIcon *status_icon, guint button,
		guint activate_time, gpointer user_data)
{
	gtk_widget_show_all(popup_menu);
	gtk_menu_popup(GTK_MENU(popup_menu), NULL, NULL,
			gtk_status_icon_position_menu, status_icon,
			button, activate_time);
}


void create_popup_menu()
{
	g_assert(!popup_menu);
	popup_menu = gtk_menu_new();

	GtkWidget *item;

	item = gtk_menu_item_new_with_label("Let's blink!");
	gtk_menu_append(popup_menu, item);
	g_signal_connect(G_OBJECT(item), "activate",
			G_CALLBACK(on_blink_change), GUINT_TO_POINTER(TRUE));

	item = gtk_menu_item_new_with_label("Let's stop blinking!");
	gtk_menu_append(popup_menu, item);
	g_signal_connect (G_OBJECT(item), "activate",
			G_CALLBACK(on_blink_change), GUINT_TO_POINTER(FALSE));

	item = gtk_menu_item_new_with_label("Quit");
	gtk_menu_append(popup_menu, item);
	g_signal_connect (G_OBJECT(item), "activate",
			G_CALLBACK(gtk_main_quit), NULL);
}

void create_status_icon()
{
	g_assert(!status_icon);
	status_icon = gtk_status_icon_new_from_stock(GTK_STOCK_ADD);
	gtk_status_icon_set_visible(status_icon, TRUE);
	//g_debug(gtk_status_icon_is_embedded(gsi));
	gtk_status_icon_set_tooltip(status_icon, "STUB TOOLTIP");
	create_popup_menu();
	g_signal_connect(G_OBJECT(status_icon), "popup-menu",
			G_CALLBACK(popup_menu_callback), NULL);
	//g_signal_connect(G_OBJECT(status_icon), "activate",
	//		G_CALLBACK(activate_callback), NULL);
}

gint main(gint argc, gchar *argv[])
{
	gtk_init(&argc, &argv);

	create_status_icon();

	gtk_main();
	return 0;
}
