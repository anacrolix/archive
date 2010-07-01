#include <netinet/ip.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <assert.h>
#include <ctype.h>
#include <error.h>
#include <netdb.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// assert will terminate in debug mode

// expect will log an error if the expression fails
#define expect(expr) ((expr) ? 0 : error_at_line(0, 0, __FILE__, __LINE__, "Expect failed: %s", #expr))

// require will terminate the process if the expression fails
#define require(expr) ((expr) ? (void)(0) : (perror(#expr), exit(EXIT_FAILURE)))

__attribute__((format(printf, 1, 2)))
void log_inner(char const *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
	fputc('\n', stderr);
}


#define my_log(format, ...) log_inner(format, ##__VA_ARGS__)

#define perror_libc

char *
sockaddr_to_numeric_string(
		struct sockaddr const *sockaddr,
		socklen_t salen)
{
	char hostbuf[NI_MAXHOST], servbuf[NI_MAXSERV];
	if (0 != getnameinfo(
			sockaddr, salen,
			hostbuf, sizeof(hostbuf),
			servbuf, sizeof(servbuf),
			NI_NUMERICHOST | NI_NUMERICSERV))
		return NULL;
	char *retval = malloc(strlen(hostbuf) + strlen(servbuf) + 2);
	strcpy(retval, hostbuf);
	strcat(retval, ",");
	strcat(retval, servbuf);
	return retval;
}

void log_new_process()
{
	my_log("New process: pid=%d", getpid());
}

char *strrepr(char const *str, size_t size)
{
	char *retval = strdup("");
	for (int i = 0; i < size; ++i) {
		char *oldrv = retval;
		if (isgraph(str[i])) {
			asprintf(&retval, "%s%c", oldrv, str[i]);
		}
		else {
			asprintf(&retval, "%s\\x%hhu", oldrv, str[i]);
		}
		free(oldrv);
	}
	return retval;
}
