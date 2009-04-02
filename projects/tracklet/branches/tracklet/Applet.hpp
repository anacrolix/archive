#include "config.h"
#include "PlayerProxies.hpp"
#include <panel-applet.h>

class Applet
{
public:
    Applet(PanelApplet *panlet);
    ~Applet();
    static gboolean factory_callback(PanelApplet *, gchar const *, gpointer);

private:
    void update_visibility();
    static void show_about_dialog(BonoboUIComponent *, gpointer, char const *);
    static gboolean event_box_pressed(GtkWidget *, GdkEventButton *, gpointer);

    PanelApplet *panlet_;
    PlayerProxies *players_;
};
