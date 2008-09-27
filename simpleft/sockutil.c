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

bool send_bytes(int const sock, void const *buf, size_t len)
{
	struct pollfd pfd = { .fd = sock, .events = POLLOUT };
	while (len > 0) {
		if (-1 == poll(&pfd, 1, -1)) {
			perror("poll");
			return false;
		}
		if (pfd.revents & POLLHUP) {
			fprintf(stderr, "receiver hung up\n");
			return false;
		}
		if (!(pfd.revents & POLLOUT)) continue;
		ssize_t sent = send(sock, buf, len, 0);
		if (sent == -1) {
			perror("send");
			return false;
		}
		buf += sent;
		len -= sent;
	}
	return true;
}
