#pragma once

#include "PlayerProxy.hpp"
#include "RhythmboxProxy.hpp"
#include <dbus/dbus-glib.h>
#include <gtk/gtk.h>
#include <list>

class PlayerProxies
{
public:
    PlayerProxies(Callback &callback)
    :   // get the session connection
        dbus_sess_conn_(dbus_g_bus_get(DBUS_BUS_SESSION, NULL)),
        // get a proxy for the dbus service bus
        dbus_service_proxy_(dbus_g_proxy_new_for_name(
                dbus_sess_conn_,
                DBUS_SERVICE_DBUS,
                DBUS_PATH_DBUS,
                DBUS_INTERFACE_DBUS)),
        callback_(callback)
    {
        g_assert(dbus_sess_conn_);
        g_assert(dbus_service_proxy_);
        // specify argument signature for callback, might not be necessary
        dbus_g_proxy_add_signal(
                dbus_service_proxy_, "NameOwnerChanged",
                G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING,
                G_TYPE_INVALID);
        // register callback to monitor for dbus connections
        dbus_g_proxy_connect_signal(
                dbus_service_proxy_, "NameOwnerChanged",
                G_CALLBACK(this->service_owner_changed),
                this, NULL);

        ppstore_.push_back(new RhythmboxProxy(dbus_sess_conn_, dbus_service_proxy_));
    }

    ~PlayerProxies()
    {
        dbus_g_proxy_disconnect_signal(
                dbus_service_proxy_, "NameOwnerChanged",
                G_CALLBACK(service_owner_changed), this);
        g_object_unref(dbus_service_proxy_);
        dbus_g_connection_unref(dbus_sess_conn_);
    }

    bool player_is_active() const
    {
        for (PlayerProxyStore::const_iterator a = ppstore_.begin(); a != ppstore_.end(); ++a)
        {
            if ((*a)->active()) return true;
        }
        return false;
    }

    void trash_current_track()
    {
        for (PlayerProxyStore::const_iterator a = ppstore_.begin(); a != ppstore_.end(); ++a)
        {
            gchar *uri;
            if ((uri = (*a)->get_playing_uri()))
            {
                gchar *dlg_text = make_dialog_text(**a);

                g_assert(dlg_text);

                gint response;
                {
                        GtkWidget *dialog = gtk_message_dialog_new(
                                        NULL, (GtkDialogFlags)0, GTK_MESSAGE_QUESTION, GTK_BUTTONS_NONE,
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
                                                NULL, (GtkDialogFlags)0, GTK_MESSAGE_ERROR, GTK_BUTTONS_CLOSE,
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
                                gchar *new_uri = (*a)->get_playing_uri();
                                if (new_uri) {
                                        if (g_strcmp0(new_uri, uri) == 0)
                                                (*a)->next_track();
                                        g_free(new_uri);
                                }
                        }
                }

                g_free(uri);
            }
        }
    }

private:
    static void service_owner_changed(
            DBusGProxy *, gchar const *service,
            gchar const *old_owner, gchar const *new_owner,
            PlayerProxies *self)
    {
        g_debug("name owner changed: %s, %s, %s", service, new_owner, old_owner);

        // notify players of service name owner change
        bool changed(false);
        for (   PlayerProxyStore::const_iterator a = self->ppstore_.begin();
                a != self->ppstore_.end() && !changed;
                ++a)
        {
            changed |= (*a)->service_owner_changed(service, new_owner);
        }

        if (changed) self->callback_();
    }

    gchar *make_dialog_text(PlayerProxy const &player)
    {
        gchar *dlg_text = NULL;

        gchar *uri = NULL;
        gchar *title = NULL, *artist = NULL, *album = NULL;
        player.get_track_properties(uri, title, artist, album);

        g_debug("uri = %s", uri);
        g_debug("%s / %s / %s", title, artist, album);

        if (title && (artist || album))
        {
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
        g_free(title);
        g_free(artist);
        g_free(album);

        if (dlg_text == NULL) {
            /* text not set by tags */
            dlg_text = g_uri_unescape_string(uri, NULL);
        }
        g_free(uri);

        return dlg_text;
    }

    typedef std::list<PlayerProxy *> PlayerProxyStore;
    PlayerProxyStore ppstore_;
    DBusGConnection *dbus_sess_conn_;
    DBusGProxy      *dbus_service_proxy_;
    Callback        &callback_;
};
