#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>

#include "error.h"

void fatal_error(const char *s, ...)
{
	perror(s);
	exit(EXIT_FAILURE);
}

void debug_error(const char *s, ...)
{
	perror(s);
	exit(EXIT_FAILURE);
}

void fatal(const char *s, ...)
{
	va_list ap;
	va_start(ap, s);
	vfprintf(stderr, s, ap);
	va_end(ap);
}

void debug(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
}
