#include <dbus/dbus-glib.h>
#include <gtk/gtk.h>

int main(gint argc, gchar **argv)
{
	g_type_init();
	gtk_init(&argc, &argv);

	DBusGConnection *conn = dbus_g_bus_get(DBUS_BUS_SESSION, NULL);
	g_assert(conn);

	DBusGProxy *proxy = dbus_g_proxy_new_for_name(
			conn,
			"org.gnome.Rhythmbox",
			"/org/gnome/Rhythmbox/Player",
			"org.gnome.Rhythmbox.Player");
	g_assert(proxy);

	gchar const *uri;
	dbus_g_proxy_call(
		proxy, "getPlayingUri", NULL,
		G_TYPE_INVALID,
		G_TYPE_STRING, &uri, G_TYPE_INVALID);
	g_debug("%s", uri);

	GtkWidget *dialog = gtk_message_dialog_new(
			NULL, 0, GTK_MESSAGE_QUESTION, GTK_BUTTONS_OK_CANCEL,
			"Do you wish to delete: %s", uri);
	gint response = gtk_dialog_run(GTK_DIALOG(dialog));
	gtk_widget_destroy(dialog);

	if (response == GTK_RESPONSE_OK) {
		GFile *file = g_file_new_for_uri(uri);
		gboolean trashed = g_file_trash(file, NULL, NULL);
		if (trashed == FALSE) {
			dialog = gtk_message_dialog_new(NULL, 0, GTK_MESSAGE_ERROR, GTK_BUTTONS_CLOSE, "Unable to delete current track!");
			gtk_dialog_run(GTK_DIALOG(dialog));
			gtk_widget_destroy(dialog);
		}
	}

	dbus_g_connection_unref(conn);

	return 0;
}
