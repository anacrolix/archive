#include "server.h"
#include "include.h"

static char *read_filename(int sock)
{
	size_t const filemax = 0x1000;
	char *filename = malloc(filemax);
	if (!filename) {
		perror("malloc");
		return NULL;
	}
	size_t next = 0;
	while (next < filemax) {
		ssize_t ssz = recv(sock, &filename[next], 1, 0);
		if (ssz == -1) {
			perror("recv");
			goto fail_recv;
		} else if (ssz == 0) {
			goto fail_recv;
		} else if (ssz == 1) {
			if (filename[next] == '\0') break;
			next++;
		} else {
			fprintf(stderr, "received too many bytes!\n");
			goto fail_recv;
		}
	}
	if (next >= filemax) {
		fprintf(stderr, "filename too long!\n");
		goto fail_recv;
	}
	assert(strlen(filename) == next);
	char *filename2 = realloc(filename, next + 1);
	return filename2 ?: filename;
fail_recv:
	free(filename);
	return NULL;
}

static bool read_filesize(int sock, uint32_t *filesize)
{
	size_t const needed = sizeof(*filesize);
	size_t left = needed;
	while (left > 0) {
		ssize_t rv = recv(sock, &((char *)filesize)[needed - left], left, 0);
		switch (rv) {
			case -1:
			case 0:
				perror("recv");
				return false;
			default:
				left -= rv;
		}
	}
	*filesize = ntohl(*filesize);
	return true;
}

static bool read_into_file(
	int const sock, size_t const size, char const *filename)
{
	FILE *fp = fopen(filename, "wx");
	if (!fp) {
		perror("fopen");
		return false;
	}
	size_t left = size;
	while (left > 0) {
		size_t const bufsize;
		char buf[bufsize];
		ssize_t ssz = recv(
			sock, buf, (left < bufsize) ? left : bufsize, 0);
		if (-1 == ssz) {
			perror("recv");
			goto fail_recv;
		} else if (ssz == 0) {
			fprintf(stderr, "client shutdown prematurely\n");
			goto fail_recv;
		}
		if (ssz != fwrite(buf, 1, ssz, fp)) {
			perror("fwrite");
			goto fail_recv;
		}
		left -= ssz;
	}
	assert(left == 0);
	assert(ftell(fp) == size);
	verify(!fclose(fp));
	return true;
fail_recv:
	if (-1 == unlink(filename)) perror("unlink");
	verify(!fclose(fp));
	return false;
}

static bool recv_file(int recvfd)
{
	bool rv = false;
	char *filename = read_filename(recvfd);
	if (!filename) return false;
	fprintf(stderr, "recv'd filename: \"%s\"\n", filename);
	uint32_t size;
	if (!read_filesize(recvfd, &size)) goto fail_free;
	rv = read_into_file(recvfd, size, filename);
fail_free:
	free(filename);
	char ack = (rv) ? 1 : 0;
	return send_bytes(recvfd, &ack, 1) && rv;
}

static struct addrinfo *
get_bind_addrinfo(char const *port)
{
	struct addrinfo hints, *res;
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE;
	int d = getaddrinfo(NULL, port, &hints, &res);
	if (d != 0) {
		errmsg("getaddrinfo", gai_strerror(d));
		return NULL;
	}
	return res;
}

void do_server(char const *port)
{
	struct addrinfo *ai = get_bind_addrinfo(port);
	assert(ai);
	int lfd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
	if (lfd == -1) {
		perror("socket");
		goto out_addrinfo;
	}
	int optval = 1;
	if (-1 == setsockopt(
		lfd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval)))
	{
		perror("setsockopt");
		goto out_socket;
	}
	if (-1 == bind(lfd, ai->ai_addr, ai->ai_addrlen)) {
		perror("bind");
		goto out_socket;
	}
	if (-1 == listen(lfd, 5)) {
		perror("listen");
		goto out_socket;
	}
	while (true) {
		struct sockaddr_storage remaddr;
		socklen_t sin_size = sizeof(remaddr);
		int newfd = accept(lfd, (struct sockaddr *)&remaddr, &sin_size);
		if (-1 == newfd) {
			perror("accept");
			continue;
		}
#if 0
		if (-1 == shutdown(newfd, SHUT_WR)) {
			perror("shutdown");
		}
#endif
		while (recv_file(newfd));
		if (-1 == close(newfd)) {
			perror("close");
			break;
		}
	}
out_addrinfo:
	freeaddrinfo(ai);
out_socket:
	verify(-1 != close(lfd));
}
