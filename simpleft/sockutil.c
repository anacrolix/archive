#include "sockutil.h"
#include "include.h"

void *get_sockaddr_sinaddr(struct sockaddr *sa)
{
	switch (sa->sa_family) {
	case AF_INET:
		return &((struct sockaddr_in *)sa)->sin_addr;
	case AF_INET6:
		return &((struct sockaddr_in6 *)sa)->sin6_addr;
	default:
		assert(false);
		break;
	}
}
