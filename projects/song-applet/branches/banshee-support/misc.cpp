#include "misc.h"

#include "config.h"

void show_about_dialog(BonoboUIComponent *, gpointer, char const *)
{
    //ThisApplet *context = user_data;
    gchar const *authors[] = {
        "Matt \"Eruanno\" Joiner <anacrolix@gmail.com>",
        NULL
    };
    gtk_show_about_dialog(
            NULL,
            "authors", authors,
            "version", PACKAGE_VERSION,
            "program-name", APPLET_FULLNAME,
            NULL);
}
