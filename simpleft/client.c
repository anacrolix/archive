#include "client.h"
#include "include.h"

static bool send_bytes(int const sock, void const *buf, size_t len)
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

static bool send_file(int sock, char const *filename)
{
	bool rv = false;
	FILE *fp = fopen(filename, "r");
	if (!fp) {
		perror("fopen");
		return false;
	}
	struct stat stat;
	if (-1 == fstat(fileno(fp), &stat)) {
		perror("fstat");
		goto fail_fp;
	}
	if (!send_bytes(sock, filename, strlen(filename) + 1)) {
		goto fail_fp;
	}
	//assert(sizeof(off_t) == sizeof(uint32_t));
	uint32_t size = htonl(stat.st_size);
	if (!send_bytes(sock, &size, sizeof(size)))
		goto fail_fp;
	while (true) {
		size_t const bufsize = 0x1000;
		char buf[bufsize];
		size_t got = fread(buf, 1, bufsize, fp);
		if (got < bufsize && ferror(fp)) goto fail_fp;
		if (!send_bytes(sock, buf, got)) goto fail_fp;
		if (got < bufsize) {
			assert(feof(fp));
			break;
		}
	}
	rv = true;
fail_fp:
	if (fclose(fp)) {
		perror("fclose");
		rv = false;
	}
	return rv;
}

static struct addrinfo *
get_serv_addrinfo(char const *host, char const *port)
{
	struct addrinfo hints, *res;
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	int d = getaddrinfo(host, port, &hints, &res);
	if (d != 0) {
		errmsg("getaddrinfo", gai_strerror(d));
		return NULL;
	}
	return res;
}

static int new_client_sock(struct addrinfo *ai)
{
	int sock = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
	if (sock == -1) {
		perror("socket");
		return -1;
	}
	if (-1 == connect(sock, ai->ai_addr, ai->ai_addrlen)) {
		perror("connect");
		goto out_socket;
	}
	if (-1 == shutdown(sock, SHUT_RD)) {
		perror("shutdown");
		goto out_socket;
	}
	return sock;
out_socket:
	verify(!close(sock));
	return -1;
}

void do_client(char const *host, char const *port, char const **files)
{
	struct addrinfo *ai = get_serv_addrinfo(host, port);
	if (!ai) return;
	int sock = -1;
	for (char const **file = files; *file; file++) {
		if (sock == -1) sock = new_client_sock(ai);
		if (sock == -1) goto out_addrinfo;
		if (!send_file(sock, *file)) {
			verify(!close(sock));
			sock = -1;
		}
	}
	if (sock != -1) verify(!close(sock));
out_addrinfo:
	freeaddrinfo(ai);
}
