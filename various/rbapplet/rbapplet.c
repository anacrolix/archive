#include <panel-applet.h>
#include <dbus/dbus-glib.h>
#include "config.h"

#define RB_DBUS_SERVICE "org.gnome.Rhythmbox"
#define RB_DBUS_PLAYER_PATH "/org/gnome/Rhythmbox/Player"
#define RB_DBUS_PLAYER_INTERFACE "org.gnome.Rhythmbox.Player"
#define RB_DBUS_SHELL_PATH "/org/gnome/Rhythmbox/Shell"
#define RB_DBUS_SHELL_INTERFACE "org.gnome.Rhythmbox.Shell"

typedef struct {
	PanelApplet *panel_applet;
	DBusGConnection *dbus_sess_conn;
	DBusGProxy *dbus_proxy, *rb_shell_proxy, *rb_player_proxy;
} ThisApplet;

static gboolean name_has_owner(DBusGProxy *proxy)
{
	// BOOLEAN NameHasOwner (in STRING name)
	gboolean has_owner;
	dbus_g_proxy_call(
		proxy, "NameHasOwner", NULL,
		G_TYPE_STRING, RB_DBUS_SERVICE, G_TYPE_INVALID,
		G_TYPE_BOOLEAN, &has_owner, G_TYPE_INVALID);
	return has_owner;
}

static void name_owner_changed(
	DBusGProxy *proxy,
	gchar const *name, gchar const *new_owner, gchar const *old_owner,
	gpointer user)
{
	ThisApplet *this = user;

	g_debug("name owner changed: %s, %s, %s", name, new_owner, old_owner);

	if (g_strcmp0(name, RB_DBUS_SERVICE))
		return;

	if (g_strcmp0(new_owner, "")) {
		/* closing */
		gtk_widget_hide_all(GTK_WIDGET(this->panel_applet));
	}
	else {
		/* opening */
		gtk_widget_show_all(GTK_WIDGET(this->panel_applet));
	}
}

static char *get_rb_playing_uri(DBusGProxy *rb_player_proxy)
{
	gchar *uri = NULL;
	GError *error = NULL;
	dbus_g_proxy_call(
			rb_player_proxy, "getPlayingUri", &error,
			G_TYPE_INVALID,
			G_TYPE_STRING, &uri,
			G_TYPE_INVALID);
	if (error) {
		g_debug("Error getting playing URI: %s", error->message);
		g_error_free(error);
	}
	else
		g_debug("Playing URI: %s", uri);

	return uri;
}

static GHashTable *get_rb_song_properties(
		DBusGProxy *rb_shell_proxy, gchar const *uri)
{
	GHashTable *ht = NULL;
	GType type = dbus_g_type_get_map(
			"GHashTable", G_TYPE_STRING, G_TYPE_VALUE);
	dbus_g_proxy_call(
			rb_shell_proxy, "getSongProperties", NULL,
			G_TYPE_STRING, uri,
			G_TYPE_INVALID,
			type, &ht,
			G_TYPE_INVALID);
	return ht;
}

static gboolean rb_next(ThisApplet *this)
{
	return dbus_g_proxy_call(this->rb_player_proxy, "next", NULL,
			G_TYPE_INVALID, G_TYPE_INVALID);
}

static gchar const *lookup_variant_string(
		GHashTable *hash_table, gpointer key)
{
	GValue const *value = g_hash_table_lookup(hash_table, key);
	if (value)
		return g_value_get_string(value);
	else
		return NULL;
}

static void trash_current_rb_uri(ThisApplet *this)
{
	/* get the current track URI */
	gchar *uri = get_rb_playing_uri(this->rb_player_proxy);

	if (!uri || g_strcmp0(uri, "") == 0) {
		GtkWidget *dialog = gtk_message_dialog_new(
				NULL, 0, GTK_MESSAGE_INFO, GTK_BUTTONS_OK,
				"No song is currently playing.");
		gtk_dialog_run(GTK_DIALOG(dialog));
		gtk_widget_destroy(dialog);
	}
	else {
		/* get the dialog text */
		gchar *dlg_text = NULL;
		{
			GHashTable *song_props = get_rb_song_properties(
					this->rb_shell_proxy, uri);

			if (song_props) {
				/* these strings are deleted by the hashtable */
				gchar const *title, *artist, *album;
				title = lookup_variant_string(song_props, "title");
				artist = lookup_variant_string(song_props, "artist");
				album = lookup_variant_string(song_props, "album");

				g_debug("%s / %s / %s", title, artist, album);

				if (title && (artist || album)) {
					/* combine tags for dialog box */
					dlg_text = g_strdup_printf("Title: %s", title);
					gchar *s;
					if (artist) {
						s = g_strdup_printf("%s\nArtist: %s", dlg_text, artist);
						g_free(dlg_text);
						dlg_text = s;
					}
					if (album) {
						s = g_strdup_printf("%s\nAlbum: %s", dlg_text, album);
						g_free(dlg_text);
						dlg_text = s;
					}
				}
				g_hash_table_destroy(song_props);
			}
			if (dlg_text == NULL) {
				/* text not set by tags */
				dlg_text = g_uri_unescape_string(uri, NULL);
			}
		}
		g_assert(dlg_text);

		gint response;
		{
			GtkWidget *dialog = gtk_message_dialog_new(
					NULL, 0, GTK_MESSAGE_QUESTION, GTK_BUTTONS_NONE,
					"Move to Trash?\n\n%s", dlg_text);
			gtk_dialog_add_buttons(GTK_DIALOG(dialog),
				GTK_STOCK_DELETE, GTK_RESPONSE_ACCEPT,
				GTK_STOCK_CANCEL, GTK_RESPONSE_REJECT,
				NULL);
			response = gtk_dialog_run(GTK_DIALOG(dialog));
			gtk_widget_destroy(dialog);
		}
		g_free(dlg_text);

		if (response == GTK_RESPONSE_ACCEPT)
		{
			/* delete the track */
			GFile *file = g_file_new_for_uri(uri);
			GError *error = NULL;
			g_file_trash(file, NULL, &error);
			if (error != NULL) {
				GtkWidget *dialog = gtk_message_dialog_new(
						NULL, 0, GTK_MESSAGE_ERROR, GTK_BUTTONS_CLOSE,
						"Error moving file to trash: %s\n", error->message);
				gtk_dialog_run(GTK_DIALOG(dialog));
				gtk_widget_destroy(dialog);
				g_error_free(error);
			}
			g_object_unref(file);

			/* skip to next track if the current uri hasn't changed
			 * (most likely due to track transition waiting for user response)
			 */
			if (error == NULL) {
				gchar *new_uri = get_rb_playing_uri(this->rb_player_proxy);
				if (new_uri) {
					if (g_strcmp0(new_uri, uri) == 0)
						rb_next(this);
					g_free(new_uri);
				}
			}
		}

	}
	if (uri) g_free(uri);
}

static gboolean delete_box_pressed(
	GtkWidget *event_box, GdkEventButton *event, gpointer user_data)
{
	g_debug("clicked");
	if (event->button == 1) {
		trash_current_rb_uri(user_data);
		return TRUE;
	}
	else {
		return FALSE;
	}
}

static gboolean rbapplet_factory(
	PanelApplet *applet, gchar const *iid, gpointer data)
{
	g_debug("requested iid: %s", iid);

	if (g_strcmp0(iid, BONOBO_APPLET_IID))
		return FALSE;

	/* allocate space for applet objects */
	gpointer this = g_malloc0(sizeof(ThisApplet));
	g_assert(this);

	/* setup dbus connection and proxies */
	DBusGConnection *dbus_sess_conn;
	DBusGProxy *dbus_proxy, *rb_shell_proxy, *rb_player_proxy;
	dbus_sess_conn = dbus_g_bus_get(DBUS_BUS_SESSION, NULL);
	g_assert(dbus_sess_conn);
	dbus_proxy = dbus_g_proxy_new_for_name(
			dbus_sess_conn,
			DBUS_SERVICE_DBUS, DBUS_PATH_DBUS, DBUS_INTERFACE_DBUS);
	g_assert(dbus_proxy);
	rb_shell_proxy = dbus_g_proxy_new_for_name(
			dbus_sess_conn,
			RB_DBUS_SERVICE, RB_DBUS_SHELL_PATH, RB_DBUS_SHELL_INTERFACE);
	g_assert(rb_shell_proxy);
	rb_player_proxy = dbus_g_proxy_new_for_name(
			dbus_sess_conn,
			RB_DBUS_SERVICE, RB_DBUS_PLAYER_PATH, RB_DBUS_PLAYER_INTERFACE);
	g_assert(rb_player_proxy);

	/* register callback to monitor for dbus connections */
	dbus_g_proxy_add_signal(
			dbus_proxy, "NameOwnerChanged",
			G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING,
			G_TYPE_INVALID);
	dbus_g_proxy_connect_signal(
			dbus_proxy, "NameOwnerChanged",
			G_CALLBACK(name_owner_changed), this, NULL);

	/* add button */
	GtkWidget *event_box = gtk_event_box_new();
	gtk_container_add(GTK_CONTAINER(applet), event_box);
	GtkWidget *delete_image = gtk_image_new_from_stock(
    		GTK_STOCK_DELETE, GTK_ICON_SIZE_SMALL_TOOLBAR);
	gtk_container_add(GTK_CONTAINER(event_box), delete_image);
	g_signal_connect(
			event_box, "button-press-event",
			G_CALLBACK(delete_box_pressed), this);

	if (name_has_owner(dbus_proxy))
		gtk_widget_show_all(GTK_WIDGET(applet));

	*(ThisApplet *)this = (ThisApplet) {
		applet, dbus_sess_conn, dbus_proxy, rb_shell_proxy, rb_player_proxy
	};

	return TRUE;
}

PANEL_APPLET_BONOBO_FACTORY(
		BONOBO_FACTORY_IID, PANEL_TYPE_APPLET, "???",
		PACKAGE_VERSION, rbapplet_factory, NULL);
