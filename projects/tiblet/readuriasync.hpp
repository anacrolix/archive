template <typename UserData>
class ReadUriAsync
{
public:
	typedef void (*Callback)(gchar *, UserData);

	ReadUriAsync(
			gchar const *uri,
			Callback cb,
			UserData ud)
	:	ud_(ud),
		cb_(cb),
		gf_(g_file_new_for_uri(uri)),
		gis_(NULL),
		buf_(NULL),
		count_(0)
	{
	}
	~ReadUriAsync()
	{
		g_object_unref(gis_);
		g_object_unref(gf_);
	}

	void start_reading(gssize max)
	{
		g_file_read_async(gf_, G_PRIORITY_DEFAULT, NULL, open_finish_cb, this);
		max_ = max;
	}

private:
	static void end_reading(ReadUriAsync *rua)
	{
		gchar *buf = rua->buf_;
		Callback cb = rua->cb_;
		UserData ud = rua->ud_;
		delete rua;
		cb(buf, ud);
	}

	void read()
	{
		g_input_stream_read_async(
				gis_, buf_ + count_, max_ - count_,
				G_PRIORITY_DEFAULT, NULL, read_finish_cb, this);
	}

	static void open_finish_cb(
			GObject *source, GAsyncResult *result, gpointer userdata)
	{
		reinterpret_cast<ReadUriAsync *>(userdata)->open_finish(
				reinterpret_cast<GFile *>(source), result);
	}
	void open_finish(GFile *gf, GAsyncResult *res)
	{
		gis_ = reinterpret_cast<GInputStream *>(
				g_file_read_finish(gf, res, NULL));
		if (gis_) {
			buf_ = new gchar[max_];
			g_assert(buf_);
			read();
		}
		else {
			end_reading(this);
		}
	}

	void read_finish(GInputStream *gis, GAsyncResult *res)
	{
		gssize bytes = g_input_stream_read_finish(gis, res, NULL);
		g_assert(bytes != -1);
		g_debug("read %zd bytes", bytes);

		if (bytes != 0) {
			count_ += bytes;
			read();
			return;
		}

		g_assert(count_ <= max_);
		if (count_ == max_) g_debug("filled entire buffer!");
		buf_[count_] = '\0';

		end_reading(this);
	}
	static void read_finish_cb(
			GObject *source, GAsyncResult *res, gpointer data)
	{
		reinterpret_cast<ReadUriAsync *>(data)->read_finish(
				reinterpret_cast<GInputStream *>(source), res);
	}

	UserData ud_;
	Callback cb_;
	GFile *gf_;
	GInputStream *gis_;
	gchar *buf_;
	gssize count_;
	gssize max_;
};
