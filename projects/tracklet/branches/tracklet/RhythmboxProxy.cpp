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
            G_TYPE_STRING, service, G_TYPE_INVALID,
            G_TYPE_BOOLEAN, &has_owner, G_TYPE_INVALID);
    this->active(has_owner);
}

gchar const *RhythmboxProxy::service_name() const
{
    return RHYTHMBOX_DBUS_SERVICE;
}
