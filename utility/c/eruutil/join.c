#include "debug.h"
#include <assert.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <errno.h>
#include <error.h>
#include <stdbool.h>

/// takes va_list of count length
static char *vjoin(const char *delimit, int count, va_list argp)
{
	assert(count > 0);
	// retrieve all the argument strings
	char *args[count];
	assert(sizeof(args) == count * sizeof(char *));
	for (int i = 0; i < count; i++) {
		args[i] = va_arg(argp, char *);
	}	
	va_end(argp);
	
	// allocate space for output string
	size_t size = 0;
	for (int i = 0; i < count; i++) {
		size += strlen(args[i]);
	}
	size += strlen(delimit) * (count - 1);
	size += 1; // term char
	char *out = malloc(size);
	if (out == NULL) {
		warn(errno, "malloc()");
		return NULL;
	}
	out[0] = '\0';
	
	// create output string
	for (int i = 0; i < count - 1; i++) {
		strcat(out, args[i]);
		strcat(out, delimit);
	}
	strcat(out, args[count - 1]);
	assert(strlen(out) + 1 == size);
	return out;
}

/// takes list of char *, count long
char *joinn(const char *delimit, int count, ...)
{
	va_list argp;
	va_start(argp, count);
	char *rv = vjoin(delimit, count, argp);
	va_end(argp);
	return rv;
}

/// takes NULL terminated list of char *
char *join0(const char *delimit, ...)
{
	va_list argp;
	// get argument count
	va_start(argp, delimit);
	int count;
	for (count = 0; va_arg(argp, char *); count++);
	va_end(argp);
	// call vjoin
	va_start(argp, delimit);
	char *rv = vjoin(delimit, count, argp);
	va_end(argp);
	// return
	return rv;
}
