#include <stddef.h>
#include <assert.h>
typedef unsigned int uint;

void *memnotchr(const void *s, int c, size_t n)
{
	assert(sizeof(char) == 1);
	assert(sizeof(void *) == sizeof(char *));
	assert(sizeof(void *) == sizeof(uint));
	char *i = (char *)s;
	while (*i++ == c && (uint)i - (uint)s != n);
	return ((uint)i - (uint)s == (uint)n) ? NULL : (void *)i;
}
