#pragma once

#include <dbus/dbus-glib.h>

class PlayerProxy
{
public:
    PlayerProxy() : active_(false) {}

    virtual gchar *get_playing_uri() const = 0;

    virtual void get_track_properties(
            gchar *&uri, gchar *&title, gchar *&artist, gchar *&album)
        const = 0;

    virtual void next_track() = 0;

    bool active() const { return active_; }

    bool service_owner_changed(gchar const *service, gchar const *newowner)
    {
        bool active(active_);
        if (g_strcmp0(service, this->service_name()) == 0)
        {
            if (g_strcmp0(newowner, "") != 0) {
                active_ = true;
            } else {
                active_ = false;
            }
        }
        return active != active_;
    }

protected:
    void active(bool active) { active_ = active; }

private:
    virtual gchar const *service_name() const = 0;

    bool active_;
};
