
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

#endif

