#include <stdio.h>
#include <gtk/gtk.h>

#define DRAG_TAR_INFO_0 0

GtkWidget *window;
GtkWidget *label;

void dndBeginDrag(
	GtkWidget *widget, GdkDragContext *dc, gpointer data)
	{}

static void dndEndDrag(
	GtkWidget *widget, GdkDragContext *dc, gpointer data)
	{}

void dndDataReceive(
	GtkWidget *widget, GdkDragContext *dc,
	gint x, gint y, GtkSelectionData *sd,
	guint info, guint t, gpointer data)
{
	//g_debug(sd->data);
	printf(sd->data);
}



int main(int argc, char *argv[])
{
	gtk_init(&argc, &argv);
	// create controls
	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	label = gtk_label_new("Drag here...");
	gtk_container_add(GTK_CONTAINER(window), label);
	GtkTargetEntry gte = {
		.target = "text/uri-list",
		.flags = 0,
		.info = 0};
	gtk_drag_dest_set(
		label, GTK_DEST_DEFAULT_MOTION | GTK_DEST_DEFAULT_HIGHLIGHT |
			GTK_DEST_DEFAULT_DROP, &gte, 1,
		GDK_ACTION_COPY | GDK_ACTION_MOVE);
	gtk_signal_connect(
			GTK_OBJECT(label), "drag_data_begin",
			GTK_SIGNAL_FUNC(dndBeginDrag), NULL);
	gtk_signal_connect(
			GTK_OBJECT(label), "drag_data_received",
			GTK_SIGNAL_FUNC(dndDataReceive), NULL);
	gtk_signal_connect(
			GTK_OBJECT(label), "drag_data_end",
			GTK_SIGNAL_FUNC(dndEndDrag), NULL);
	gtk_widget_show(label);
	gtk_widget_show(window);
	// main loop
	gtk_main();
	return 0;
}
