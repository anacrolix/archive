#ifndef ERUDEBUG_H
#define ERUDEBUG_H

#include <error.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <assert.h>

#define fatal(errval, fmt, ...) \
	(error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

// should this be debug only?
#define static_assert(cond) \
	extern char dummy_assert_array[(cond)?1:-1]

// replace debug_size with this?
#define psize debug_size

#ifdef NDEBUG
	#define verify(f) ((f) ? (void)(0):(void)(0))
	#define warn(errval, fmt, ...) \
		(error(0, errval, fmt, ##__VA_ARGS__))
		//({fprintf(stderr, fmt, ##__VA_ARGS__); fputc('\n', stderr);})
	#define debug(fmt, ...)
	#define debugln(fmt, ...)
	#define debug_size(type)
	#define dump(var, fmt)
#else
	#define verify(f) (assert(f))
	#define warn(errval, fmt, ...) \
		(error_at_line(0, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))
	#define debug(fmt, ...) \
		(fprintf(stderr, fmt, ##__VA_ARGS__))
	#define debugln(fmt, ...) \
		({fprintf(stderr, fmt, ##__VA_ARGS__); fputc('\n', stderr);})
	// maybe change this to psize()?
	#define debug_size(type) (error_at_line(0, 0, __FILE__, __LINE__, \
		"sizeof(" #type ") = %lu", sizeof(type)))
	#define dump(var, fmt) \
		({fprintf(stderr, "%s: %s = " fmt, __func__, #var, var); \
		fputc('\n', stderr);})
#endif

#endif
