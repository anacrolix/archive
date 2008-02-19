#ifndef error_h
#define error_h

#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <assert.h>

#define err_fatal fatal_error
#define err_debug debug

void fatal_error(const char *, ...);
void debug_error(const char *, ...);
/*
void fatal(const char *, ...);
void debug(const char *, ...);
*/
#define debug(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
#define \
	fatal(fmt, ...) { \
		fprintf(stderr, fmt, ##__VA_ARGS__); \
		exit(EXIT_FAILURE); \
	}

#endif
