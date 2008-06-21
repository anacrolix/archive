#include <gtk/gtk.h>

int main(int argc, char **argv)
{
	gtk_init(&argc, &argv);
	GtkWidget *dialog = gtk_message_dialog_new(
		NULL, 0, GTK_MESSAGE_QUESTION, GTK_BUTTONS_YES_NO, "hi");
	gtk_dialog_run(GTK_DIALOG(dialog));
	//gtk_widget_destroy(dialog);
	gtk_main();
}
