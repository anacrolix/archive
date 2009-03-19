#include <panel-applet.h>
#include "config.h"

class Applet
{
public:
    Applet(PanelApplet *panlet);

    static gboolean factory_callback(PanelApplet *panlet, gchar const *iid, gpointer)
    {
        g_warn_if_fail(!g_strcmp0(iid, BONOBO_APPLET_IID));
        new Applet(panlet);
        return TRUE;
    }

private:
    static void show_about_dialog(BonoboUIComponent *, gpointer, char const *);
    static gboolean event_box_pressed(
            GtkWidget *event_box, GdkEventButton *event, gpointer userdata);

    void update_visibility();

    PanelApplet *panlet_;
};
