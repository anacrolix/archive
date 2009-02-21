#include "debug.h"
#include <stdlib.h>
#include <error.h>
#include <errno.h>

/// allocates zeroed memory or exits fatally
void *xmalloc0(size_t size)
{
	static_assert(sizeof(char unsigned) == 1);
	void *p = calloc(size, 1);
	if (p == NULL && size != 0)
		fatal(errno, "calloc()");
	return p;
}

/// allocates nmemb * size bytes of zeroed memory or exits fatally
void *xcalloc(size_t nmemb, size_t size)
{
	void *p = calloc(nmemb, size);
	if (p == NULL && nmemb != 0 && size != 0)
		fatal(errno, "calloc()");
	return p;
}
