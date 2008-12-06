template <typename UserData>
class ReadUriAsync
{
public:
	typedef void (*Callback)(gchar *, UserData, ReadUriAsync *);

	ReadUriAsync(
			gchar const *uri,
			Callback cb,
			UserData ud)
	:	ud_(ud),
		gf_(g_file_new_for_uri(uri)),
		count_(0),
		cb_(cb)
	{
	}
	~ReadUriAsync()
	{
		g_object_unref(gf_);
	}
	void readall(gssize max)
	{
		GInputStream *gis = reinterpret_cast<GInputStream *>(
				g_file_read(gf_, NULL, NULL));
		g_assert(gis);
		buf_ = new gchar[max];
		g_assert(buf_);
		max_ = max;
		read(gis);
	}

private:
	void read(GInputStream *gis)
	{
		g_input_stream_read_async(
				gis, buf_ + count_, max_ - count_,
				G_PRIORITY_DEFAULT, NULL, read_finish_cb, this);
	}
	void read_finish(GInputStream *gis, GAsyncResult *res)
	{
		gssize bytes = g_input_stream_read_finish(gis, res, NULL);
		g_assert(bytes != -1);
		g_debug("read %zd bytes", bytes);

		if (bytes != 0) {
			count_ += bytes;
			read(gis);
			return;
		}

		g_object_unref(gis);
		g_assert(count_ != max_);
		buf_[count_] = '\0';

		cb_(buf_, ud_, this);
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
	gchar *buf_;
	gssize count_;
	gssize max_;
};
