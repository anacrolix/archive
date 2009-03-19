#pragma once

#include <dbus/dbus-glib.h>

class Player
{
public:
    Player(DBusGProxy *dbus, char const *service)
    :   active_(dbus_has_owner(dbus, service))
    {
    }

    gboolean dbus_has_owner(DBusGProxy *dbus, char const *service)
    {
        gboolean has_owner;
        // BOOLEAN NameHasOwner (in STRING name)
        dbus_g_proxy_call(
                dbus, "NameHasOwner", NULL,
                G_TYPE_STRING, service, G_TYPE_INVALID,
                G_TYPE_BOOLEAN, &has_owner, G_TYPE_INVALID);
        return has_owner;
    }

    bool service_owner_changed(char const *service, char const *newowner)
    {
        bool active(active_);
        if (g_strcmp0(service, this->get_service_name()) == 0)
        {
            if (g_strcmp0(newowner, "") != 0) {
                active_ = true;
            } else {
                active_ = false;
            }
        }
        return active != active_;
    }

    virtual char const *get_service_name() const = 0;
    bool get_active() const { return active_; }

protected:
    static DBusGProxy *get_dbus_g_proxy(
            DBusGConnection *bus,
            char const *name,
            char const *path,
            char const *interface)
    {
        DBusGProxy *proxy = dbus_g_proxy_new_for_name(
                bus, name, path, interface);
        g_assert(proxy);
        return proxy;
    }

private:
    bool active_;
};
