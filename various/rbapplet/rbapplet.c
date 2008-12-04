#include <panel-applet.h>
#include <dbus/dbus-glib.h>

#define EXE_IID "OAFIID:RhythmboxApplet"
#define FACTORY_IID EXE_IID "_Factory"

typedef struct {
	PanelApplet *applet;
} ThisApplet;

static gboolean name_has_owner(DBusGProxy *proxy)
{
	// BOOLEAN NameHasOwner (in STRING name)
	gboolean has_owner;
	dbus_g_proxy_call(
		proxy, "NameHasOwner", NULL,
		G_TYPE_STRING, "org.gnome.Rhythmbox", G_TYPE_INVALID,
		G_TYPE_BOOLEAN, &has_owner, G_TYPE_INVALID);
	return has_owner;
}

static void name_owner_changed(
	DBusGProxy *proxy,
	gchar const *name, gchar const *new_owner, gchar const *old_owner,
	gpointer user)
{
	ThisApplet *this = user;

	g_debug("name owner changed: %s, %s, %s", name, new_owner, old_owner);

	if (g_strcmp0(name, "org.gnome.Rhythmbox"))
		return;

	if (g_strcmp0(new_owner, "")) {
		/* closing */
		gtk_widget_hide_all(GTK_WIDGET(this->applet));
	}
	else {
		/* opening */
		gtk_widget_show_all(GTK_WIDGET(this->applet));
	}
}

static void delete_button_clicked(GtkButton *button, gpointer user)
{
	g_debug("clicked");
}

static gboolean rbapplet_factory(
	PanelApplet *applet, gchar const *iid, gpointer data)
{
	//g_type_init();
	//g_thread_init(NULL);
	//dbus_g_thread_init();

	g_debug("requested exe iid: %s", iid);

	ThisApplet *this = g_malloc(sizeof(ThisApplet));
	g_assert(this);
	this->applet = applet;

	/* setup dbus */

	DBusGConnection *conn = dbus_g_bus_get(DBUS_BUS_SESSION, NULL);
	g_assert(conn);

	DBusGProxy *proxy = dbus_g_proxy_new_for_name(
			conn, DBUS_SERVICE_DBUS, DBUS_PATH_DBUS, DBUS_INTERFACE_DBUS);
	g_assert(proxy);

	dbus_g_proxy_add_signal(proxy, "NameOwnerChanged",
			G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_INVALID);

	dbus_g_proxy_connect_signal(
			proxy, "NameOwnerChanged", G_CALLBACK(name_owner_changed), this, NULL);

	/* add button */

	GtkWidget *delete_button = gtk_image_new_from_stock(
    		GTK_STOCK_DELETE, GTK_ICON_SIZE_SMALL_TOOLBAR);
	gtk_container_add(GTK_CONTAINER(applet), delete_button);
	g_signal_connect(delete_button, "clicked", delete_button_clicked, this);

	if (name_has_owner(proxy))
		gtk_widget_show_all(GTK_WIDGET(applet));

	return TRUE;
}

PANEL_APPLET_BONOBO_FACTORY(
		FACTORY_IID, PANEL_TYPE_APPLET, "Rhythmbox Applet",
		"0", rbapplet_factory, NULL);
