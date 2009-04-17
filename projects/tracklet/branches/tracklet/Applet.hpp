#include "Callback.hh"
#include "PlayerProxies.hpp"
#include "config.h"
#include <panel-applet.h>

class Applet
{
public:
    static gboolean factory_callback(PanelApplet *, gchar const *, gpointer);

    Applet(PanelApplet *panlet);
    ~Applet();

    void update_visibility();

private:
    static void show_about_dialog(BonoboUIComponent *, gpointer, char const *);
    static gboolean event_box_pressed(GtkWidget *, GdkEventButton *, Applet *);

    PanelApplet *panlet_;
    Callback *callback_;
    PlayerProxies *players_;
};
