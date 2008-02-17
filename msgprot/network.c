#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

#include "error.h"

int tcp_connect(char *name, unsigned short int port)
{
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if (sock == -1) err_fatal("socket");
	struct hostent *he;
	he = gethostbyname(name);
	if (he == NULL) err_fatal("gethostbyname");
	struct sockaddr_in addr = {
		.sin_family = AF_INET,
		.sin_port = htons(port),
		.sin_addr = *((struct in_addr *)he->h_addr)};
	if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) == -1)
		err_fatal("connect");
	return sock;
}

int tcp_listen(unsigned short int port, unsigned int backlog)
{
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if (sock == -1) err_fatal("socket");
	int soptval = 1;
	if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &soptval, sizeof soptval) == -1)
		err_fatal("setsockopt");
	struct sockaddr_in addr = {
		.sin_family = AF_INET,
		.sin_addr.s_addr = INADDR_ANY,
		.sin_port = htons(port)};
	if (bind(sock, (struct sockaddr *)&addr, sizeof addr) == -1)
		err_fatal("bind");
	if (listen(sock, backlog) == -1) err_fatal("listen");		
	return sock;
}

int tcp_accept(int socket)
{
	int newsock = accept(socket, NULL, 0);
	if (newsock == -1) err_fatal("accept");
	return newsock;
}

char *tcp_peer_host(int socket)
{
	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(addr);
	if (getpeername(socket, (struct sockaddr *)&addr, &addrlen) == -1)
		err_fatal("getpeername");
	return inet_ntoa(addr.sin_addr);	
}

unsigned short int tcp_peer_port(int socket)
{
	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(addr);
	if (getpeername(socket, (struct sockaddr *)&addr, &addrlen) == -1)
		err_fatal("getpeername");
	return ntohs(addr.sin_port);
}
