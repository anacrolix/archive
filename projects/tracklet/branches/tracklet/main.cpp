#include "Applet.hpp"
#include "config.h"
#include <panel-applet.h>

PANEL_APPLET_BONOBO_FACTORY(
        BONOBO_FACTORY_IID, PANEL_TYPE_APPLET, "The applet ID string.",
        PACKAGE_VERSION, &Applet::factory_callback, NULL);
