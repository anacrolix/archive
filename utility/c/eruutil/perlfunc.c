#include <string.h>
#include <assert.h>
#include <stdarg.h>
#include <stdlib.h>
#include <errno.h>
#include <stdbool.h>
#include "erudebug.h"

bool chomp(char *str, char c)
{
	size_t len = strlen(str);
	if (str[len - 1] == c) {
		str[len - 1] = '\0';
		return true;
	} else {
		return false;
	}
}

char *join(const char *delimit, int count, ...)
{
	// retrieve all the argument strings
	assert(count > 0);
	char *args[count];
	assert(sizeof(args) == count * sizeof(char *));
	va_list argp;
	va_start(argp, count);
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
