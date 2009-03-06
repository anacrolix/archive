#pragma once

#include <dbus/dbus-glib.h>

class Player
{
public:
    Player(DBusGProxy *dbus)
    :   active_(dbus_has_owner(dbus))
    {
    }

    gboolean dbus_has_owner(DBusGProxy *dbus)
    {
        gboolean has_owner;
        // BOOLEAN NameHasOwner (in STRING name)
        dbus_g_proxy_call(
                dbus, "NameHasOwner", NULL,
                G_TYPE_STRING, this->get_service_name(), G_TYPE_INVALID,
                G_TYPE_BOOLEAN, &has_owner, G_TYPE_INVALID);
        return has_owner;
    }

    void set_active(bool active)
    {
        active_ = active;
    }

    bool get_active() const { return active_; }

    virtual gchar const *get_service_name() const = 0;

protected:
    static DBusGProxy *get_dbus_g_proxy(
            DBusGConnection *dbusgconn,
            char const *name,
            char const *path,
            char const *interface)
    {
        DBusGProxy *proxy = dbus_g_proxy_new_for_name(
                dbusgconn, name, path, interface);
        g_assert(proxy);
        return proxy;
    }

private:
    bool active_;
};
