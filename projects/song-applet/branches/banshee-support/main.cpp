#include "Player.hpp"
#include "Rhythmbox.hpp"

#include "config.h"

#include <dbus/dbus-glib.h>
#include <gio/gio.h>
#include <gtk/gtk.h>
#include <panel-applet.h>

#include <boost/bind.hpp>

#include <list>

using namespace std;

struct Applet
{
    typedef list<Player *> PlayerList;

    PanelApplet     *panel_applet_;
    DBusGConnection *dbus_sess_conn_;
    PlayerList       player_list_;
    DBusGProxy      *dbus_service_proxy_;

    Applet(PanelApplet *panlet)
    :   panel_applet_(panlet),
        dbus_sess_conn_(dbus_g_bus_get(DBUS_BUS_SESSION, NULL)),
        dbus_service_proxy_(dbus_g_proxy_new_for_name(
                dbus_sess_conn_,
                DBUS_SERVICE_DBUS,
                DBUS_PATH_DBUS,
                DBUS_INTERFACE_DBUS))
    {
        // register callback to monitor for dbus connections
        dbus_g_proxy_add_signal(
                dbus_service_proxy_, "NameOwnerChanged",
                G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING,
                G_TYPE_INVALID);
        dbus_g_proxy_connect_signal(
                dbus_service_proxy_, "NameOwnerChanged",
                G_CALLBACK(&Applet::name_owner_changed),
                this, NULL);

        // add button
        GtkWidget *event_box = gtk_event_box_new();
        gtk_container_add(GTK_CONTAINER(panel_applet_), event_box);
        GtkWidget *delete_image = gtk_image_new_from_stock(
                GTK_STOCK_DELETE, GTK_ICON_SIZE_SMALL_TOOLBAR);
        gtk_container_add(GTK_CONTAINER(event_box), delete_image);
#if 0
        g_signal_connect(
                event_box, "button-press-event",
                G_CALLBACK(delete_box_pressed), context);
#endif

        /* setup menu */
        static char const menu_xml[] =
            "<popup name=\"button3\">\n"
                "<menuitem "
                    "name=\"Item 1\" "
                    "verb=\"RbAppletAbout\" "
                    "label=\"_About\" "
                    "pixtype=\"stock\" "
                    "pixname=\"gnome-stock-about\" "
                "/>\n"
            "</popup>\n";
        static BonoboUIVerb const menu_verbs[] = {
#if 0
            BONOBO_UI_VERB("RbAppletAbout", show_about_dialog),
#endif
            BONOBO_UI_VERB_END
        };
        panel_applet_setup_menu(panel_applet_, menu_xml, menu_verbs, this);

#if 0
        /* show applet if RB is running */
        if (name_has_owner(dbus_proxy))
            gtk_widget_show_all(GTK_WIDGET(applet));
#endif
        player_list_.push_back(new Rhythmbox(dbus_service_proxy_, dbus_sess_conn_));

        this->update_visibility();
    }

    static gboolean factory(
            PanelApplet *panlet, gchar const *iid, gpointer)
    {
        g_debug("requested iid: %s", iid);

        if (g_strcmp0(iid, BONOBO_APPLET_IID))
            return FALSE;

        Applet *applet = new Applet(panlet);

        return TRUE;
    }

private:
    static void name_owner_changed(
            DBusGProxy *, gchar const *name,
            gchar const *new_owner, gchar const *old_owner,
            Applet *userdata)
    {
        g_debug("name owner changed: %s, %s, %s", name, new_owner, old_owner);

        /* update the active state of any player whose service name matches */
        for (   PlayerList::iterator plyrit = userdata->player_list_.begin();
                plyrit != userdata->player_list_.end(); ++plyrit)
        {
            if (name == (*plyrit)->get_service_name())
            {
                (*plyrit)->set_active(g_strcmp0(new_owner, "") != 0);
            }
        }

        userdata->update_visibility();
    }

    void update_visibility()
    {
        for (   PlayerList::const_iterator it = player_list_.begin();
                it != player_list_.end(); ++it)
        {
            if ((*it)->get_active()) {
                gtk_widget_show_all(GTK_WIDGET(this->panel_applet_));
                return;
            }
        }
        gtk_widget_hide_all(GTK_WIDGET(this->panel_applet_));
    }
};

#if 0

static void name_owner_changed(
    DBusGProxy *proxy,
    gchar const *name, gchar const *new_owner, gchar const *old_owner,
    gpointer user)
{
}

static char *get_rhythmbox_playing_uri(DBusGProxy *rhythmbox_player_proxy)
{
    gchar *uri = NULL;
    GError *error = NULL;
    dbus_g_proxy_call(
            rhythmbox_player_proxy, "getPlayingUri", &error,
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

static GHashTable *get_rhythmbox_song_properties(
        DBusGProxy *rhythmbox_shell_proxy, gchar const *uri)
{
    GHashTable *ht = NULL;
    GType type = dbus_g_type_get_map(
            "GHashTable", G_TYPE_STRING, G_TYPE_VALUE);
    dbus_g_proxy_call(
            rhythmbox_shell_proxy, "getSongProperties", NULL,
            G_TYPE_STRING, uri,
            G_TYPE_INVALID,
            type, &ht,
            G_TYPE_INVALID);
    return ht;
}

static gboolean rhythmbox_next(ThisApplet *applet)
{
    return dbus_g_proxy_call(applet->rhythmbox_player_proxy, "next", NULL,
            G_TYPE_INVALID, G_TYPE_INVALID);
}

static gchar const *lookup_variant_string(
        GHashTable *hash_table, void const *key)
{
    GValue const *value = reinterpret_cast<GValue const *>(g_hash_table_lookup(hash_table, key));
    if (value)
        return g_value_get_string(value);
    else
        return NULL;
}

static void trash_current_rhythmbox_uri(ThisApplet *applet)
{
    /* get the current track URI */
    gchar *uri = get_rhythmbox_playing_uri(applet->rhythmbox_player_proxy);

    if (!uri || g_strcmp0(uri, "") == 0) {
        GtkWidget *dialog = gtk_message_dialog_new(
                NULL, static_cast<GtkDialogFlags>(0), GTK_MESSAGE_INFO, GTK_BUTTONS_OK,
                "No song is currently playing.");
        gtk_dialog_run(GTK_DIALOG(dialog));
        gtk_widget_destroy(dialog);
    }
    else {
        /* get the dialog text */
        gchar *dlg_text = NULL;
        {
            GHashTable *song_props = get_rhythmbox_song_properties(
                    applet->rhythmbox_shell_proxy, uri);

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
                    NULL, static_cast<GtkDialogFlags>(0), GTK_MESSAGE_QUESTION, GTK_BUTTONS_NONE,
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
                        NULL, static_cast<GtkDialogFlags>(0), GTK_MESSAGE_ERROR, GTK_BUTTONS_CLOSE,
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
                gchar *new_uri = get_rhythmbox_playing_uri(applet->rhythmbox_player_proxy);
                if (new_uri) {
                    if (g_strcmp0(new_uri, uri) == 0)
                        rhythmbox_next(applet);
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
        trash_current_rhythmbox_uri(reinterpret_cast<ThisApplet *>(user_data));
        return TRUE;
    }
    else {
        return FALSE;
    }
}

static void show_about_dialog(
    BonoboUIComponent *component, gpointer, char const *cname)
{
    //ThisApplet *context = user_data;
    gchar const *authors[] = {
        "Matt \"Eruanno\" Joiner <anacrolix@gmail.com>",
        NULL
    };
    gtk_show_about_dialog(
            NULL,
            "authors", authors,
            "version", PACKAGE_VERSION,
            "program-name", APPLET_FULLNAME,
            NULL);
}

#endif

PANEL_APPLET_BONOBO_FACTORY(
        BONOBO_FACTORY_IID, PANEL_TYPE_APPLET, "???",
        PACKAGE_VERSION, &Applet::factory, NULL);
