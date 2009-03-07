#pragma once

#include "Player.hpp"
#include "Rhythmbox.hpp"

#include "misc.h"
#include "config.h"

#include <dbus/dbus-glib.h>
#include <panel-applet.h>

#include <list>

class Applet
{
public:
    Applet(PanelApplet *panlet)
    :   panel_applet_(panlet),
        dbus_sess_conn_(dbus_g_bus_get(DBUS_BUS_SESSION, NULL)),
        dbus_service_proxy_(dbus_g_proxy_new_for_name(
                dbus_sess_conn_,
                DBUS_SERVICE_DBUS,
                DBUS_PATH_DBUS,
                DBUS_INTERFACE_DBUS))
    {
        // register callback to monitor for dbus connections
        dbus_g_proxy_add_signal(
                dbus_service_proxy_, "NameOwnerChanged",
                G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING,
                G_TYPE_INVALID);
        dbus_g_proxy_connect_signal(
                dbus_service_proxy_, "NameOwnerChanged",
                G_CALLBACK(&Applet::name_owner_changed),
                this, NULL);

        // add button
        GtkWidget *event_box = gtk_event_box_new();
        gtk_container_add(GTK_CONTAINER(panel_applet_), event_box);
        GtkWidget *delete_image = gtk_image_new_from_stock(
                GTK_STOCK_DELETE, GTK_ICON_SIZE_SMALL_TOOLBAR);
        gtk_container_add(GTK_CONTAINER(event_box), delete_image);
#if 0
        g_signal_connect(
                event_box, "button-press-event",
                G_CALLBACK(delete_box_pressed), context);
#endif

        /* setup menu */
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
        panel_applet_setup_menu(panel_applet_, menu_xml, menu_verbs, this);

        player_list_.push_back(new Rhythmbox(dbus_service_proxy_, dbus_sess_conn_));

        this->update_visibility();
    }

    static gboolean factory(
            PanelApplet *panlet, gchar const *iid, gpointer)
    {
        g_debug("requested iid: %s", iid);

        if (g_strcmp0(iid, BONOBO_APPLET_IID))
            return FALSE;

        Applet *applet = new Applet(panlet);

        return TRUE;
    }

private:
    typedef std::list<Player *> PlayerList;

    PanelApplet     *panel_applet_;
    DBusGConnection *dbus_sess_conn_;
    PlayerList       player_list_;
    DBusGProxy      *dbus_service_proxy_;

    static void name_owner_changed(
            DBusGProxy *, gchar const *service,
            gchar const *new_owner, gchar const *old_owner,
            Applet *userdata)
    {
        g_debug("name owner changed: %s, %s, %s", service, new_owner, old_owner);

        // notify players of service name owner change
        bool changed(false);
        PlayerList::iterator plyrit;
        for (   plyrit = userdata->player_list_.begin();
                plyrit != userdata->player_list_.end(); ++plyrit)
        {
            changed |= (*plyrit)->service_owner_changed(service, new_owner);
        }

        if (changed) userdata->update_visibility();
    }

    void update_visibility()
    {
        PlayerList::const_iterator it;
        for (   it = player_list_.begin();
                it != player_list_.end(); ++it)
        {
            if ((*it)->get_active()) {
                gtk_widget_show_all(GTK_WIDGET(this->panel_applet_));
                return;
            }
        }
        gtk_widget_hide_all(GTK_WIDGET(this->panel_applet_));
    }
};
