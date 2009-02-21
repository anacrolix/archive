#include "debug.h"
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <errno.h>
#include <error.h>

char *mprintf(const char *fmt, ...)
{
	size_t size = 0x100;
	char *s = malloc(size);
	if (!s) return NULL;
	while (true) {
		// print to the buffer
		va_list ap;
		va_start(ap, fmt);
		int n = vsnprintf(s, size, fmt, ap);
		va_end(ap);
		// check for fit
		if (n == -1) {
			// glibc <2.0.6 output truncated
			size *= 2;
		} else if (n >= 0 && n < size - 1) {
			// buffer too big
			char *ns = realloc(s, n + 1);
			if (ns) {
				return ns;
			} else {
				warn(errno, "realloc()");
				return s;
			}
		} else if (n == size - 1) {
			// buffer just right
			return s;
		} else if (n >= size) {
			// buffer too small
			size = n + 1;
		}
		// enlargen buffer
		char *ns = realloc(s, size);
		if (!ns) {
			warn(errno, "realloc()");
			free(s);
			return NULL;
		}
		s = ns;
	}
}
