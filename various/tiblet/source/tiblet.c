#include <string.h>

#include <panel-applet.h>
#include <gtk/gtklabel.h>
#include <gio/gio.h>

#define EXE_IID "OAFIID:TibiaApplet"
#define FACTORY_IID EXE_IID "_Factory"
#define WORLD_URI "http://www.tibia.com/community/" \
	"?subtopic=whoisonline&world=Dolera&order=level"
#define COUNT_PATTERN "Currently (\\d+) players are online\\."
#define MAX_PAGESIZE (300 * 1024)
#define UPDATE_INTERVAL_S (15 * 60)
#define PIXMAPS_DIR "/usr/share/pixmaps/"

typedef struct {
	PanelApplet *applet;
	GtkWidget *label;
	GRegex *regex;
} TibiaApplet;

static void update_label(TibiaApplet *tiblet)
{
	GFile *gf = g_file_new_for_uri(WORLD_URI);

	GInputStream *gis = g_file_read(gf, NULL, NULL);
	g_assert(gis);

	gchar *buf = g_malloc(MAX_PAGESIZE);
	g_assert(buf);

	gssize count = 0, zd;
	while ((zd = g_input_stream_read(
				gis, buf + count, MAX_PAGESIZE - count, NULL, NULL)))
	{
		g_assert(zd != -1);
		count += zd;
	}
	g_debug("Read %zd bytes", count);

	g_object_unref(gis);
	g_object_unref(gf);

	g_assert(count != MAX_PAGESIZE);
	buf[count] = '\0';

	GMatchInfo *mi;
	gchar *text;
	if (g_regex_match(tiblet->regex, buf, 0, &mi)) {
		text = g_match_info_fetch(mi, 1);
		g_assert(text);
		g_debug("Matched \"%s\"", text);
	}
	else {
		text = g_strdup("Fail");
	}
	gtk_label_set_text(GTK_LABEL(tiblet->label), text);
	g_free(text);
	g_match_info_free(mi);

	g_free(buf);
}

static gboolean timeout_function(gpointer data)
{
	update_label(data);
	return TRUE;
}

static gboolean initial_update(gpointer data)
{
	update_label(data);
	return FALSE;
}

static gboolean tibia_applet_factory(
	PanelApplet *applet, const gchar *iid, gpointer data)
{
    if (strcmp(iid, EXE_IID) != 0)
        return FALSE;

	TibiaApplet *tiblet = g_malloc(sizeof(TibiaApplet));
	tiblet->applet = applet;

    GtkWidget *image, *box;

	box = gtk_hbox_new(FALSE, 3);
    tiblet->label = gtk_label_new("Tiblet");
    image = gtk_image_new_from_file(PIXMAPS_DIR "tiblet.xpm");
    g_assert(image);
    GdkPixbuf *pixbuf = gdk_pixbuf_scale_simple(
    		gtk_image_get_pixbuf(image), 24, 24, GDK_INTERP_HYPER);
    gtk_image_set_from_pixbuf(image, pixbuf);

	gtk_container_add(GTK_CONTAINER(applet), box);
	gtk_container_add(GTK_CONTAINER(box), image);
    gtk_container_add(GTK_CONTAINER(box), tiblet->label);

    gtk_widget_show_all (GTK_WIDGET (applet));

    tiblet->regex = g_regex_new(
    		"Currently (\\d+) players are online.",
    		G_REGEX_OPTIMIZE, 0, NULL);

    g_idle_add(initial_update, tiblet);
    g_timeout_add_seconds(UPDATE_INTERVAL_S, timeout_function, tiblet);

    return TRUE;
}

PANEL_APPLET_BONOBO_FACTORY(
		FACTORY_IID, PANEL_TYPE_APPLET, "Tibia Applet",
		"0", tibia_applet_factory, NULL);
