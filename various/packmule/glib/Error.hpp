#include <glib.h>
#include <exception>
#include <iostream>

namespace glib {

class Error : public std::exception
{
public:
	Error(GError *e) throw ()
		:	error_(e)
	{}

	virtual ~Error() throw () {
		g_error_free(error_);
		error_ = NULL;
	}

	virtual const char *what() const throw()
	{
		return error_->message;
	}

private:
	GError *error_;
};

} // namespace glib
