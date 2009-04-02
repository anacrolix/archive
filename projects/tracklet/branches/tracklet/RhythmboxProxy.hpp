#pragma once

#include "PlayerProxy.hpp"
#include <dbus/dbus-glib.h>

class RhythmboxProxy : public PlayerProxy
{
public:
    RhythmboxProxy(DBusGConnection *, DBusGProxy *);
    //~RhythmboxProxy();

private:
    virtual gchar const *service_name() const;

    DBusGProxy *shell_proxy_;
    DBusGProxy *player_proxy_;
};
