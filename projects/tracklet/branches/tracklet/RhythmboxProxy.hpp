#pragma once

#include "PlayerProxy.hpp"
#include <dbus/dbus-glib.h>

class RhythmboxProxy : public PlayerProxy
{
public:
    RhythmboxProxy(DBusGConnection *, DBusGProxy *);

private:
    virtual gchar const *service_name() const;
    virtual gchar *get_playing_uri() const;
    virtual void get_track_properties(
            gchar *&uri, gchar *&title, gchar *&artist, gchar *&album)
        const;
    virtual void next_track();

    gchar *get_current_uri() const;

    DBusGProxy *shell_proxy_;
    DBusGProxy *player_proxy_;
};
