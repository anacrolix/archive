#include <assert.h>
#include <errno.h>
#include <error.h>
#include <netdb.h>
#include <poll.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>

#include "sockutil.h"

#ifndef NDEBUG
#define verify(x) do { assert(x); } while (false)
#else
#define verify(x) do { x; } while (false)
#endif

#define errmsg(function, errorstr) do { \
		fprintf(stderr, "%s: %s\n", (function), (errorstr)); \
	} while (false)
