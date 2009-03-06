#include "Player.hpp"

#define RHYTHMBOX_DBUS_SERVICE "org.gnome.Rhythmbox"
#define RHYTHMBOX_DBUS_PLAYER_PATH "/org/gnome/Rhythmbox/Player"
#define RHYTHMBOX_DBUS_PLAYER_INTERFACE "org.gnome.Rhythmbox.Player"
#define RHYTHMBOX_DBUS_SHELL_PATH "/org/gnome/Rhythmbox/Shell"
#define RHYTHMBOX_DBUS_SHELL_INTERFACE "org.gnome.Rhythmbox.Shell"


class Rhythmbox : public Player
{
public:
    virtual gchar const *get_service_name() const { return RHYTHMBOX_DBUS_SERVICE; }

    Rhythmbox(
            DBusGProxy *dbus,
            DBusGConnection *session)
    :   Player(dbus), // super constructor can't call virtual functions yet!
        shell_proxy_(get_dbus_g_proxy(session,
                get_service_name(),
                RHYTHMBOX_DBUS_SHELL_PATH,
                RHYTHMBOX_DBUS_SHELL_INTERFACE)),
        player_proxy_(get_dbus_g_proxy(session,
                get_service_name(),
                RHYTHMBOX_DBUS_PLAYER_PATH,
                RHYTHMBOX_DBUS_PLAYER_INTERFACE))
    {
    }

private:
    DBusGProxy *shell_proxy_;
    DBusGProxy *player_proxy_;
};
