#include "Applet.hpp"
#include "Player.hpp"
#include "Rhythmbox.hpp"

#include "config.h"

#include <gio/gio.h>
#include <gtk/gtk.h>




PANEL_APPLET_BONOBO_FACTORY(
        BONOBO_FACTORY_IID, PANEL_TYPE_APPLET, "???",
        PACKAGE_VERSION, &Applet::factory, NULL);
