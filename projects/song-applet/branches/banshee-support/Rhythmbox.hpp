#pragma once

#include "Player.hpp"

#define RHYTHMBOX_DBUS_SERVICE "org.gnome.Rhythmbox"
#define RHYTHMBOX_DBUS_PLAYER_PATH "/org/gnome/Rhythmbox/Player"
#define RHYTHMBOX_DBUS_PLAYER_INTERFACE "org.gnome.Rhythmbox.Player"
#define RHYTHMBOX_DBUS_SHELL_PATH "/org/gnome/Rhythmbox/Shell"
#define RHYTHMBOX_DBUS_SHELL_INTERFACE "org.gnome.Rhythmbox.Shell"

class Rhythmbox : public Player
{
public:
    Rhythmbox(
            DBusGProxy *dbus,
            DBusGConnection *session)
    :   Player(dbus, RHYTHMBOX_DBUS_SERVICE),
        shell_proxy_(get_dbus_g_proxy(session,
                RHYTHMBOX_DBUS_SERVICE,
                RHYTHMBOX_DBUS_SHELL_PATH,
                RHYTHMBOX_DBUS_SHELL_INTERFACE)),
        player_proxy_(get_dbus_g_proxy(session,
                RHYTHMBOX_DBUS_SERVICE,
                RHYTHMBOX_DBUS_PLAYER_PATH,
                RHYTHMBOX_DBUS_PLAYER_INTERFACE))
    {
    }

    virtual char const *get_service_name() const { return RHYTHMBOX_DBUS_SERVICE; }

private:
    DBusGProxy *const shell_proxy_;
    DBusGProxy *const player_proxy_;
};
