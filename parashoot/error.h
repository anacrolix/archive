#include <stdio.h>
#include <stdlib.h>

#ifdef DEBUG
#define debug(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
#else
#define debug
#endif
#define \
	fatal(fmt, ...) { \
		fprintf(stderr, fmt, ##__VA_ARGS__); \
		exit(EXIT_FAILURE); \
	}
