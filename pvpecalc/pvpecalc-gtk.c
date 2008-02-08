#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <gtk/gtk.h>
#include "tibia-xp.h"

#define MAX_LEVEL 1000
#define MIN_LEVEL 6

const gchar windowTitle[] = "PvP-E XP Calc";

GtkWidget
	*labelExpGain,
	*labelExpLoss,
	*labelLevelGain,
	*labelLevelLoss,
	*spinVictimLevel,
	*spinKillerLevel,
	*buttonVictimPremium;

void label_underline_text(GtkLabel *label)
{
	const gchar *text = gtk_label_get_text(label);
	size_t len = strlen(text);
	int start, end;
	for (start = 0; start < len && isblank(text[start]); start++);
	for (end = len - 1; end >= 0 && isblank(text[end]); end--);
	fprintf(stderr, "will underline [%d, %d]\n", start, end);
	gchar *pattern = malloc(len);
	memset(pattern, ' ', len);
	memset(pattern + start, '_', end - start + 1);
	gtk_label_set_pattern(label, pattern);
	free(pattern);
}

GtkWidget *label_new_attach_table(GtkTable *table, guint left_attach, guint right_attach, guint top_attach, guint bottom_attach, gchar *str, gfloat xalign, gfloat yalign, gboolean underline)
{
	GtkWidget *w = gtk_label_new(str);
	gtk_table_attach_defaults(GTK_TABLE(table), w, left_attach, right_attach, top_attach, bottom_attach);
	gtk_misc_set_alignment(GTK_MISC(w), xalign, yalign);
	if (underline) label_underline_text(GTK_LABEL(w));
	gtk_widget_show(w);
	return w;
}

void update_exp_gain_label(void)
{
	/* get exp gain parameters */
	gint victim_level = gtk_spin_button_get_value_as_int(GTK_SPIN_BUTTON(spinVictimLevel));
	gint killer_level = gtk_spin_button_get_value_as_int(GTK_SPIN_BUTTON(spinKillerLevel));

	tibia_exp_t exp_gain = tibia_pvp_kill_exp_gain(killer_level, victim_level);
	tibia_level_t level_gain = tibia_level_from_exp(tibia_exp_for_level(killer_level) + exp_gain) - killer_level;

	tibia_exp_t exp_loss = tibia_exp_loss_from_death(tibia_exp_for_level(victim_level), gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(buttonVictimPremium)));
	tibia_level_t level_loss = tibia_level_from_exp(tibia_exp_for_level(victim_level) * 0.93) - victim_level;

	///* create largest possible string */
	//char max_str[0x20];
	//tibia_exp_t max_exp_gain = tibia_pvp_kill_exp_gain(MIN_LEVEL, MAX_LEVEL);
	//tibia_level_t max_level_gain = tibia_level_from_exp(tibia_exp_for_level(MIN_LEVEL) + max_exp_gain) - MIN_LEVEL;
	//sprintf(max_str, "%u (+%u)", max_exp_gain, max_level_gain);
	///* set maximum label dimensions */
	//GtkRequisition req;
	//gtk_label_set_text(GTK_LABEL(labelExpGain), max_str);
	//gtk_widget_size_request(labelExpGain, &req);
	//gtk_widget_set_size_request(labelExpGain, req.width, req.height);

	/* create actual label string */
	char s[0x20];
	sprintf(s, "+%llu", exp_gain);
	gtk_label_set_text(GTK_LABEL(labelExpGain), s);
	sprintf(s, "+%llu", level_gain);
	gtk_label_set_text(GTK_LABEL(labelLevelGain), s);
	sprintf(s, "-%llu", exp_loss);
	gtk_label_set_text(GTK_LABEL(labelExpLoss), s);
	sprintf(s, "%-lld", level_loss);
	gtk_label_set_text(GTK_LABEL(labelLevelLoss), s);
}

void spin_level_change(GtkSpinButton *spin, gpointer data)
{
	update_exp_gain_label();
}

int main(int argc, char *argv[])
{
	GtkWidget *tmp_align;
	gtk_init(&argc, &argv);

	//window
	GtkWidget *window;
	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_title(GTK_WINDOW(window), windowTitle);
	g_signal_connect(GTK_OBJECT(window), "destroy", G_CALLBACK(gtk_main_quit), NULL);
	gtk_container_set_border_width(GTK_CONTAINER(window), 5);
	gtk_window_set_resizable(GTK_WINDOW(window), FALSE);

	//vbox1
	GtkWidget *vbox1 = gtk_vbox_new(FALSE, 5);
	gtk_container_add(GTK_CONTAINER(window), vbox1);
	gtk_widget_show(vbox1);

	//table
	GtkWidget *table = gtk_table_new(3, 2, FALSE);
	gtk_box_pack_start(GTK_BOX(vbox1), table, FALSE, FALSE, 0);
	gtk_widget_show(table);

	//victim label
	tmp_align = gtk_alignment_new(0.0, 0.5, 0.0, 0.0);
	gtk_table_attach_defaults
		(GTK_TABLE(table), tmp_align, 0, 1, 0, 1);
	gtk_widget_show(tmp_align);
	GtkWidget *victim_label = gtk_label_new("Victim level");
	gtk_container_add(GTK_CONTAINER(tmp_align), victim_label);
	gtk_widget_show(victim_label);

	//killer label
	tmp_align = gtk_alignment_new
		(0.0, 0.5, 0.0, 0.0);
	gtk_table_attach_defaults
		(GTK_TABLE(table), tmp_align, 0, 1, 1, 2);
	gtk_widget_show(tmp_align);
	GtkWidget *killer_label = gtk_label_new("Killer level");
	gtk_container_add(GTK_CONTAINER(tmp_align), killer_label);
	gtk_widget_show(killer_label);

	//victim adjustment
	GtkObject *victim_adj = gtk_adjustment_new(MIN_LEVEL, MIN_LEVEL, MAX_LEVEL, 1, 10, 0);

	//killer adjustment
	GtkObject *killer_adj = gtk_adjustment_new(MIN_LEVEL, MIN_LEVEL, MAX_LEVEL, 1, 10, 0);

	//victim spin
	spinVictimLevel = gtk_spin_button_new(
		GTK_ADJUSTMENT(victim_adj), 0.1, 0);
	gtk_table_attach_defaults(GTK_TABLE(table), spinVictimLevel,
		2, 3, 0, 1);
	g_signal_connect(
		G_OBJECT(victim_adj),
		"value_changed",
		G_CALLBACK(spin_level_change),
		NULL);
	gtk_widget_show(spinVictimLevel);

	//killer spin
	spinKillerLevel = gtk_spin_button_new
		(GTK_ADJUSTMENT(killer_adj), 0.01, 0);
	gtk_table_attach_defaults(GTK_TABLE(table), spinKillerLevel,
		2, 3, 1, 2);
	g_signal_connect(G_OBJECT(spinKillerLevel), "value_changed",
		G_CALLBACK(spin_level_change), NULL);
	gtk_widget_show(spinKillerLevel);

	buttonVictimPremium = gtk_check_button_new_with_label("Victim premium?");
	gtk_table_attach_defaults(GTK_TABLE(table), buttonVictimPremium, 0, 2, 2, 3);
	g_signal_connect(buttonVictimPremium, "toggled", G_CALLBACK(update_exp_gain_label), NULL);
	gtk_widget_show(buttonVictimPremium);

	//separator
	GtkWidget *separator = gtk_hseparator_new();
	gtk_box_pack_start(GTK_BOX(vbox1), separator, FALSE, FALSE, 0);
	gtk_widget_show(separator);

	/* table to hold results */
	GtkWidget *tableResults = gtk_table_new(3, 3, FALSE);
	gtk_box_pack_start(GTK_BOX(vbox1), tableResults, FALSE, FALSE, 0);
	gtk_widget_show(tableResults);
	/* contents of results table */
	label_new_attach_table(GTK_TABLE(tableResults), 0, 1, 0, 1, NULL, 0.0, 0.5, FALSE);
	label_new_attach_table(GTK_TABLE(tableResults), 1, 2, 0, 1, "Experience", 1.0, 0.5, TRUE);
	label_new_attach_table(GTK_TABLE(tableResults), 2, 3, 0, 1, " Level", 1.0, 0.5, TRUE);
	label_new_attach_table(GTK_TABLE(tableResults), 0, 1, 1, 2, "Victim: ", 0.0, 0.5, FALSE);
	labelExpLoss = label_new_attach_table(GTK_TABLE(tableResults), 1, 2, 1, 2, NULL, 1.0, 0.5, FALSE);
	labelLevelLoss = label_new_attach_table(GTK_TABLE(tableResults), 2, 3, 1, 2, NULL, 1.0, 0.5, FALSE);
	label_new_attach_table(GTK_TABLE(tableResults), 0, 1, 2, 3, "Killer: ", 0.0, 0.5, FALSE);
	labelExpGain = label_new_attach_table(GTK_TABLE(tableResults), 1, 2, 2, 3, NULL, 1.0, 0.5, FALSE);
	labelLevelGain = label_new_attach_table(GTK_TABLE(tableResults), 2, 3, 2, 3, NULL, 1.0, 0.5, FALSE);
	/* update and show all */
	update_exp_gain_label();
	gtk_widget_show(window);
	/* enter gtk loop */
	gtk_main();

	return 0;
}

