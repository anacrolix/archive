#include <glib.h>
#include <iostream>

using namespace std;
using namespace glib;

class CopyChannel
{
public:
	CopyChannel(IoChannel &src, IoChannel &dst, gsize bufsize = 512)
		:	src_(src),
			dst_(dst),
			event_id_(-1),
			count_(0),
			bufsize_(bufsize)
	{
		buf_ = new gchar[bufsize_];
		add_read_watch();
	}

	~CopyChannel()
	{
		cerr << "~" << endl;
		delete[] buf_;
	}

private:
	static gboolean read_ready(
			GIOChannel *source, GIOCondition condition, gpointer data)
	{
		return reinterpret_cast<CopyChannel *>(data)->read();
	}

	static gboolean write_ready(
			GIOChannel *source, GIOCondition condition, gpointer data)
	{
		return reinterpret_cast<CopyChannel *>(data)->write();
	}

	void add_read_watch()
	{
		assert(event_id_ = -1);
		event_id_ = src_.add_watch(G_IO_IN, read_ready, this);
		cerr << "added watch: " << event_id_ << endl;
	}

	void add_write_watch()
	{
		assert(event_id_ = -1);
		event_id_ = dst_.add_watch(G_IO_OUT, write_ready, this);
		cerr << "added watch: " << event_id_ << endl;
	}

	gboolean read()
	{
		assert(count_ == 0);

		gsize readc;
		GIOStatus status;

		status = src_.read_chars(buf_, bufsize_, readc);
		cerr << "read " << readc << " bytes" << endl;

		switch (status)
		{
		case G_IO_STATUS_AGAIN:
		case G_IO_STATUS_NORMAL:
			if (readc > 0) {
				count_ = readc;
				event_id_ = -1;
				add_write_watch();
				return FALSE;
			} else {
				return TRUE;
			}
		case G_IO_STATUS_EOF:
			assert(readc == 0);
			assert(count_ == 0);
			dst_.flush();
			cerr << "EOF" << endl;
			event_id_ = -1;
			return FALSE;
		}
		g_assert_not_reached();
	}

	gboolean write()
	{
		assert(count_ > 0);

		gsize written;
		GIOStatus status;

		status = dst_.write_chars(buf_, count_, written);
		cerr << "wrote " << written << " bytes" << endl;

		switch (status)
		{
		case G_IO_STATUS_AGAIN:
			assert(written == 0);
			return TRUE;
		case G_IO_STATUS_NORMAL:
			assert(written == count_);
			count_ = 0;
			event_id_ = -1;
			add_read_watch();
			return FALSE;
		}
		g_assert_not_reached();
	}

	gchar *buf_;
	gsize const bufsize_;
	gsize count_;
	guint event_id_;
	IoChannel &src_, &dst_;
};
