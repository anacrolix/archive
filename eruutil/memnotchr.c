#include <stddef.h>
#include <assert.h>
#include "erudebug.h"

typedef unsigned int uint;

static_assert(sizeof(char) == 1);
static_assert(sizeof(void *) == sizeof(char *));
static_assert(sizeof(void *) == sizeof(uint));

void *memnotchr(const void *s, int c, size_t n)
{
	char *i = (char *)s;
	while (*i++ == c && (uint)i - (uint)s != n);
	return ((uint)i - (uint)s == (uint)n) ? NULL : (void *)i;
}
