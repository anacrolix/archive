#pragma once

#ifdef NDEBUG
	//#define verify(f) ((f) ? (void)(0):(void)(0))
#else
	#define static_assert(cond) \
		__attribute__((unused)) extern char \
		dummy_assert_array[(cond) ? 1 : -1]

	#define verify(f) (assert(f))

	#define warn(errval, fmt, ...) \
		(error_at_line(0, errval, __FILE__, __LINE__, \
		fmt, ##__VA_ARGS__))

	#define fatal(errval, fmt, ...) \
		(error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, \
		fmt, ##__VA_ARGS__))

	#define debug(fmt, ...) \
		(fprintf(stderr, fmt, ##__VA_ARGS__))

	#define psize(type) \
		(error_at_line(0, 0, __FILE__, __LINE__, \
		"sizeof(" #type ") : %lu", sizeof(type)))

	#define trace(fmt, var) \
		(error_at_line(0, 0, __FILE__, __LINE__, "%s : " fmt, #var, var))
#endif
