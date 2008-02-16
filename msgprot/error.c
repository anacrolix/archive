#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>

#include "error.h"

void fatal_error(char *s)
{
	perror(s);
	exit(EXIT_FAILURE);
}

void debug(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
}
