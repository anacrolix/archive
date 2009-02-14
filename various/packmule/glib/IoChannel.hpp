#include "Error.hpp"
#include <glib.h>
#include <cassert>
#include <iostream>

namespace glib {

class IoChannel
{
public:
	IoChannel(gchar const *filename, gchar const *mode, gchar const *encoding = NULL)
	{
		GError *e = NULL;
		gio_channel_ = g_io_channel_new_file(filename, mode, &e);
		//assert((gio_channel_ && !e) || (!gio_channel_ && e));
		if (e) throw glib::Error(e);
		g_io_channel_set_encoding(gio_channel_, encoding, &e);
		if (e) throw Error(e);
	}

	~IoChannel()
	{
		this->flush();
	}

	guint add_watch(GIOCondition cond, GIOFunc func, gpointer data)
	{
		return g_io_add_watch(gio_channel_, cond, func, data);
	}

	GIOStatus read_chars(gchar *buf, gsize bufsize, gsize &bytes_read)
	{
		GError *error = NULL;
		GIOStatus status = g_io_channel_read_chars(
				gio_channel_, buf, bufsize, &bytes_read, &error);
		if (error) throw glib::Error(error);
		return status;
	}

	GIOStatus write_chars(gchar const *buf, gssize count, gsize &written)
	{
		GError *error = NULL;
		GIOStatus status = g_io_channel_write_chars(
				gio_channel_, buf, count, &written, &error);
		if (error) throw Error(error);
		return status;
	}

	GIOStatus flush()
	{
		GError *error = NULL;
		GIOStatus status;
		status = g_io_channel_flush(gio_channel_, &error);
		if (error) throw glib::Error(error);
		return status;
	}

private:
	friend class CopyChannel;
	GIOChannel *gio_channel_;
};

} // namespace glib
