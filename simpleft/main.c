#include <assert.h>
#include <errno.h>
#include <netdb.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>

#ifndef NDEBUG
#define verify(x) do { assert(x); } while (false)
#else
#define verify(x) do { x; } while (false)
#endif

enum {
	SERVER,
	CLIENT,
} mode = CLIENT;

char **files = NULL;
char *host = NULL, *port = NULL;
struct addrinfo *ai;

bool do_options(int *, char ***);
void do_addrinfo();
void do_client();
void do_server();

int main(int argc, char *argv[])
{
	if (!do_options(&argc, &argv))
		return EXIT_FAILURE;

	do_addrinfo();

	switch (mode) {
	case CLIENT:
		do_client();
		break;
	case SERVER:
		do_server();
		break;
	}

	freeaddrinfo(ai);

	return EXIT_SUCCESS;
}

void do_addrinfo()
{
	struct addrinfo hints;
	void *vp;
	int d;
	vp = memset(&hints, 0, sizeof(hints));
	assert(vp == &hints);
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags |= (mode == SERVER) ? AI_PASSIVE : 0;
	d = getaddrinfo(host, port, &hints, &ai);
	assert(!d); // gai_strerror() if problems
}

bool do_options(int *pargc, char **pargv[])
{
	assert(optind == 1);
	assert(!getenv("POSIXLY_CORRECT"));
	assert(opterr);
	int opt;
	while ((opt = getopt(*pargc, *pargv, "lp:h:")) != -1) {
		switch (opt) {
		case 'l':
			mode = SERVER;
			break;
		case 'p': {
			port = optarg;
			break;
		} case '?':
			return false;
		case 'h':
			host = optarg;
			break;
		default: assert(false);
		}
	}
	assert(optind <= *pargc);
	switch (mode) {
	case SERVER:
		assert(!host);
		if (optind < *pargc)
			fprintf(stderr, "server mode does not require file arguments\n");
		break;
	case CLIENT:
		files = &(*pargv)[optind];
		assert(host);
#ifndef NDEBUG
		if (optind == *pargc) break;
		printf("files: ");
		while ((*pargv)[optind])
			printf("\"%s\", ", (*pargv)[optind++]);
		printf("\n");
#endif
		break;
	}
	return true;
}

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

void recv_file(int recvfd)
{
	// should get pathmax here (pathconf/sysconf)?
	char path[0x100] = {'\0'};
	long next = 0;
	while (true) {
		assert(next < sizeof(path));
		ssize_t ssz = recv(recvfd, &path[next], 1, 0);
		assert(ssz >= -1 && ssz <= 1);
		if (ssz == -1) {
			perror("recv");
			return;
		} else if (ssz == 0) {
			continue;
		} else if (ssz == 1) {
			if (path[next] == '\0') break;
			next++;
		}
	}
	printf("recv'd filename: \"%s\"\n", path);
	FILE *fp = fopen(path, "wx"); // write-only, open exclusively
	if (!fp) {
		perror("fopen");
		return;
	}
	while (true) {
		char buf[0x1000];
		ssize_t ssz = recv(recvfd, buf, sizeof(buf), 0);
		if (ssz == -1) {
			perror("recv");
			goto out_fp;
		} else if (ssz == 0) break;
		verify(ssz == fwrite(buf, 1, ssz, fp));
	}
out_fp:
	printf("received %ld bytes\n", ftell(fp));
	verify(!fclose(fp));
}

void do_server()
{
	int sockfd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
	int optval = 1;
	verify(!setsockopt(
		sockfd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval)));
	verify(!bind(sockfd, ai->ai_addr, ai->ai_addrlen));
	verify(!listen(sockfd, 5));
	while (true) {
		struct sockaddr_storage remaddr;
		socklen_t sin_size = sizeof(remaddr);
		int newfd = accept(sockfd, &remaddr, &sin_size);
		assert(newfd != -1);
		char s[INET6_ADDRSTRLEN];
		verify(s == inet_ntop(
			remaddr.ss_family, get_sockaddr_sinaddr(&remaddr),
			s, sizeof(s)));
		printf("accepted %s\n", s);
		verify(!shutdown(SHUT_WR));
		recv_file(newfd);
		verify(!shutdown(newfd, SHUT_RDWR));
		verify(!close(newfd));
	}
}

bool send_file(char *filename)
{
	int sock, c;
	char s[INET6_ADDRSTRLEN];
	FILE *fp;

	verify(-1 != (sock = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol)));
	verify(s == inet_ntop(ai->ai_family, get_sockaddr_sinaddr(ai->ai_addr), s, sizeof(s)));
	fprintf(stderr, "connecting to %s\n", s);
	verify(-1 != connect(sock, ai->ai_addr, ai->ai_addrlen));
	verify(!shutdown(sock, SHUT_RD));
	verify(strlen(filename)+1 == send(sock, filename, strlen(filename)+1, 0));
	fprintf(stderr, "sent filename (%lu bytes)\n", strlen(filename)+1);
	verify(fp = fopen(filename, "r"));
	while ((c = fgetc(fp)) != EOF) {
		char b = c;
		ssize_t ssz = send(sock, &b, 1, MSG_NOSIGNAL);
		if (ssz == 1) continue;
		perror("send");
		printf("send returned %ld\n", ssz);
		goto out;
	}
	verify(!ferror(fp) && feof(fp));
out:
	printf("sent %ld bytes\n", ftell(fp));
	verify(!close(sock));
}

void do_client()
{
	assert(*files);
	char **filename = files;
	assert(filename);
	do send_file(*filename); while (*++filename);
}
