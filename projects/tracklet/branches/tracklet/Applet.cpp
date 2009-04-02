#include "RhythmboxProxy.hpp"
#include "Applet.hpp"

Applet::Applet(PanelApplet *panlet)
:   panlet_(panlet)
{
    /* widgets */

    // add event box to panel applet
    GtkWidget *event_box = gtk_event_box_new();
    gtk_container_add(GTK_CONTAINER(panlet_), event_box);
    // put an icon in the event box
    GtkWidget *delete_image = gtk_image_new_from_stock(
            GTK_STOCK_DELETE, GTK_ICON_SIZE_SMALL_TOOLBAR);
    gtk_container_add(GTK_CONTAINER(event_box), delete_image);
    // catch mouse clicks on the event box
    g_signal_connect(
            event_box, "button-press-event",
            G_CALLBACK(event_box_pressed), this);

    /* menu */

    static char const menu_xml[] =
        "<popup name=\"button3\">\n"
            "<menuitem "
                "name=\"Item 1\" "
                "verb=\"RbAppletAbout\" "
                "label=\"_About\" "
                "pixtype=\"stock\" "
                "pixname=\"gnome-stock-about\" "
            "/>\n"
        "</popup>\n";
    static BonoboUIVerb const menu_verbs[] = {
        BONOBO_UI_VERB("RbAppletAbout", show_about_dialog),
        BONOBO_UI_VERB_END
    };
    panel_applet_setup_menu(panlet_, menu_xml, menu_verbs, this);

    players_ = new PlayerProxies();

    update_visibility();
}

Applet::~Applet()
{
}

void Applet::show_about_dialog(BonoboUIComponent *, gpointer, char const *)
{
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

gboolean Applet::event_box_pressed(
    GtkWidget *event_box, GdkEventButton *event, gpointer userdata)
{
    //Applet *applet = reinterpret_cast<Applet *>(userdata);
    g_debug("event box clicked");
    if (event->button == 1)
    {   // LMB
        //trash_current_rhythmbox_uri(applet);
        // don't invoke further handlers
        return TRUE;
    }
    else {
        // propagate this event
        return FALSE;
    }
}

void Applet::update_visibility()
{
    if (players_->player_is_active()) {
        gtk_widget_show_all(GTK_WIDGET(panlet_));
    } else {
        gtk_widget_hide_all(GTK_WIDGET(panlet_));
    }
}

gboolean Applet::factory_callback(PanelApplet *panlet, gchar const *iid, gpointer)
{
    g_debug("tracklet-" PACKAGE_VERSION " starting");
    g_warn_if_fail(!g_strcmp0(iid, BONOBO_APPLET_IID));
    new Applet(panlet);
    return TRUE;
}
