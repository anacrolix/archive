#include "miniplay.h"

static NotifyNotification *notify_ = NULL;

void mp_notify_init()
{
	notify_ = notify_notification_new_with_status_icon(
		"Summary", NULL, "miniplay/play-icon.svg", mp_get_status_icon());
}

static void
append_tag_for_notify(
		GstTagList const *list, gchar const *tag, gpointer user)
{
	/* retrieve this tags value */
	gchar *value;
	if (	gst_tag_get_type(tag) != G_TYPE_STRING ||
			!gst_tag_list_get_string(list, tag, &value) ||
			!value)
		return;

	/* make a line for the notification */
	gchar *line = g_strdup_printf("%s: %s", tag, value);
	g_free(value);

	/* append to the given string */
	gchar **cur_body = user;
	gchar *new_body;
	if (*cur_body) {
		new_body = g_strjoin("\n", *cur_body, line, NULL);
		g_free(*cur_body);
	} else {
		new_body = g_strdup(line);
	}
	g_free(line);
	*cur_body = new_body;
}


void mp_notify_track(GstTagList const *tags)
{
	gchar *body = NULL;
	gst_tag_list_foreach(tags, append_tag_for_notify, &body);
	notify_notification_update(notify_, "hi", body, NULL);
	notify_notification_show(notify_, NULL);
}
