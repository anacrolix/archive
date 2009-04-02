#pragma once

#include "RhythmboxProxy.hpp"
#include "PlayerProxy.hpp"
#include <dbus/dbus-glib.h>
#include <list>

class PlayerProxies
{
public:
    PlayerProxies()
    :   // get the session connection
        dbus_sess_conn_(dbus_g_bus_get(DBUS_BUS_SESSION, NULL)),
        // get a proxy for the dbus service bus
        dbus_service_proxy_(dbus_g_proxy_new_for_name(
                dbus_sess_conn_,
                DBUS_SERVICE_DBUS,
                DBUS_PATH_DBUS,
                DBUS_INTERFACE_DBUS))
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
                G_CALLBACK(service_owner_changed),
                this, NULL);

        ppstore_.push_back(new RhythmboxProxy(dbus_sess_conn_, dbus_service_proxy_));
    }

    ~PlayerProxies()
    {
#if 0
        dbus_g_proxy_disconnect_signal(dbus_service_proxy_, "NameOwnerChanged", G_CALLBACK(service_owner_changed), this);
        g_object_unref(dbus_service_proxy_);
        dbus_g_connection_unref(dbus_sess_conn_);
#endif
    }

    bool player_is_active() const
    {
        for (PlayerProxyStore::const_iterator a = ppstore_.begin(); a != ppstore_.end(); ++a)
        {
            if ((*a)->active()) return true;
        }
        return false;
    }

private:
    static void service_owner_changed(
            DBusGProxy *, gchar const *service,
            gchar const *new_owner, gchar const *old_owner,
            PlayerProxies *self)
    {
        g_debug("name owner changed: %s, %s, %s", service, new_owner, old_owner);

        // notify players of service name owner change
        bool changed(false);
        for (   PlayerProxyStore::const_iterator a = self->ppstore_.begin();
                a != self->ppstore_.end();
                ++a)
        {
            changed |= (*a)->service_owner_changed(service, new_owner);
        }

        //if (changed) self->update_visibility();
    }

    typedef std::list<PlayerProxy *> PlayerProxyStore;
    PlayerProxyStore ppstore_;
    DBusGConnection *dbus_sess_conn_;
    DBusGProxy      *dbus_service_proxy_;
};
