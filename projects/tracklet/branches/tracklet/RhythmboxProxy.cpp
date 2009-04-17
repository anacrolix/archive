#include "RhythmboxProxy.hpp"
#include <dbus/dbus-glib.h>

#define RHYTHMBOX_DBUS_SERVICE           "org.gnome.Rhythmbox"
#define RHYTHMBOX_DBUS_PLAYER_PATH      "/org/gnome/Rhythmbox/Player"
#define RHYTHMBOX_DBUS_PLAYER_INTERFACE  "org.gnome.Rhythmbox.Player"
#define RHYTHMBOX_DBUS_SHELL_PATH       "/org/gnome/Rhythmbox/Shell"
#define RHYTHMBOX_DBUS_SHELL_INTERFACE   "org.gnome.Rhythmbox.Shell"

RhythmboxProxy::RhythmboxProxy(DBusGConnection *session, DBusGProxy *service)
{
    shell_proxy_ = dbus_g_proxy_new_for_name(session,
            RHYTHMBOX_DBUS_SERVICE,
            RHYTHMBOX_DBUS_SHELL_PATH,
            RHYTHMBOX_DBUS_SHELL_INTERFACE);
    g_assert(shell_proxy_);
    player_proxy_ = dbus_g_proxy_new_for_name(session,
            RHYTHMBOX_DBUS_SERVICE,
            RHYTHMBOX_DBUS_PLAYER_PATH,
            RHYTHMBOX_DBUS_PLAYER_INTERFACE);
    g_assert(player_proxy_);

    gboolean has_owner;
    // BOOLEAN NameHasOwner (in STRING name)
    dbus_g_proxy_call(
            service, "NameHasOwner", NULL,
            G_TYPE_STRING, RHYTHMBOX_DBUS_SERVICE, G_TYPE_INVALID,
            G_TYPE_BOOLEAN, &has_owner, G_TYPE_INVALID);
    this->active(has_owner);
}

gchar const *RhythmboxProxy::service_name() const
{
    return RHYTHMBOX_DBUS_SERVICE;
}

gchar *RhythmboxProxy::get_playing_uri() const
{
    gboolean playing = NULL;
    GError *error = NULL;
    dbus_g_proxy_call(
            player_proxy_, "getPlaying", &error,
            G_TYPE_INVALID,
            G_TYPE_BOOLEAN, &playing,
            G_TYPE_INVALID);
    if (error) {
        g_debug("Error getting playing URI: %s", error->message);
        g_error_free(error);
    }
    else {
        g_debug("Rhythmbox is playing: %d", playing);
    }
    if (playing) {
        return get_current_uri();
    } else {
        return NULL;
    }
}

gchar *RhythmboxProxy::get_current_uri() const
{
    gchar *uri = NULL;
    dbus_g_proxy_call(
            player_proxy_, "getPlayingUri", NULL,
            G_TYPE_INVALID,
            G_TYPE_STRING, &uri,
            G_TYPE_INVALID);
    return uri;
}

static gchar *lookup_variant_string(
        GHashTable *hash_table, void const *key)
{
    GValue const *value = reinterpret_cast<GValue const *>(g_hash_table_lookup(hash_table, key));
    if (value)
        return g_value_dup_string(value);
    else
        return NULL;
}

void RhythmboxProxy::get_track_properties(
        gchar *&uri, gchar *&title, gchar *&artist, gchar *&album)
    const
{
    uri = get_current_uri();
    if (uri == NULL) return;

    GType type = dbus_g_type_get_map(
            "GHashTable", G_TYPE_STRING, G_TYPE_VALUE);
    GHashTable *ht = NULL;
    dbus_g_proxy_call(
            shell_proxy_, "getSongProperties", NULL,
            G_TYPE_STRING, uri,
            G_TYPE_INVALID,
            type, &ht,
            G_TYPE_INVALID);

    title = lookup_variant_string(ht, "title");
    artist = lookup_variant_string(ht, "artist");
    album = lookup_variant_string(ht, "album");
}

void RhythmboxProxy::next_track()
{
    gboolean b = dbus_g_proxy_call(
            player_proxy_, "next", NULL,
            G_TYPE_INVALID, G_TYPE_INVALID);
    g_assert(b);
}
