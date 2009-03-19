#include <dbus/dbus-glib.h>

static void name_owner_changed(
	DBusGProxy *proxy,
	gchar const *name, gchar const *new_owner, gchar const *old_owner,
	gpointer user)
{
	g_debug("name owner changed: %s, %s, %s", name, new_owner, old_owner);
}

gboolean name_has_owner(DBusGProxy *proxy)
{
	// BOOLEAN NameHasOwner (in STRING name)
	gboolean has_owner;
	dbus_g_proxy_call(
		proxy, "NameHasOwner", NULL,
		G_TYPE_STRING, "org.gnome.Rhythmbox", G_TYPE_INVALID,
		G_TYPE_BOOLEAN, &has_owner, G_TYPE_INVALID);
	return has_owner;
}

void catch_signal()
{
	g_type_init();
	//g_thread_init(NULL);
	//dbus_g_thread_init();

	DBusGConnection *conn = dbus_g_bus_get(DBUS_BUS_SESSION, NULL);
	g_assert(conn);

	DBusGProxy *proxy = dbus_g_proxy_new_for_name(
			conn, DBUS_SERVICE_DBUS, DBUS_PATH_DBUS, DBUS_INTERFACE_DBUS);
	g_assert(proxy);

	/* receive name, new_owner, old_owner */
	dbus_g_proxy_add_signal(proxy, "NameOwnerChanged", G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_INVALID);

	dbus_g_proxy_connect_signal(
			proxy, "NameOwnerChanged", G_CALLBACK(name_owner_changed), NULL, NULL);

	g_debug("has owner already: %d", name_has_owner(proxy));

	GMainLoop *loop = g_main_loop_new(NULL, FALSE);
	g_main_loop_run(loop);

	dbus_g_connection_unref(conn);
}

int main()
{
	catch_signal();

	return 0;
}
