#include "error.h"

#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

int tcp_connect(char *name, unsigned short int port)
{
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if (sock == -1) fatal_error("socket");
	struct hostent *he;
	he = gethostbyname(name);
	if (he == NULL) fatal_error("gethostbyname");
	struct sockaddr_in addr = {
		.sin_family = AF_INET,
		.sin_port = htons(port),
		.sin_addr = *((struct in_addr *)he->h_addr)};
	if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) == -1)
		fatal_error("connect");
	return sock;
}

int tcp_listen(unsigned short int port, unsigned int backlog)
{
	int sock = socket(PF_INET, SOCK_STREAM, 0);
	if (sock == -1) fatal_error("socket");
	int soptval = 1;
	if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &soptval, sizeof soptval) == -1)
		fatal_error("setsockopt");
	struct sockaddr_in addr = {
		.sin_family = AF_INET,
		.sin_addr.s_addr = INADDR_ANY,
		.sin_port = htons(port)};
	if (bind(sock, (struct sockaddr *)&addr, sizeof addr) == -1)
		fatal_error("bind");
	if (listen(sock, backlog) == -1) fatal_error("listen");		
	return sock;
}

int tcp_accept(int socket)
{
/*	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(addr);
*/	int newsock = accept(socket, NULL, 0);
	if (newsock == -1) fatal_error("accept");
	return newsock;
}

char *tcp_peer_host(int socket)
{
	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(addr);
	if (getpeername(socket, (struct sockaddr *)&addr, &addrlen) == -1)
		fatal_error("getpeername");
	return inet_ntoa(addr.sin_addr);	
}

unsigned short int tcp_peer_port(int socket)
{
	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(addr);
	if (getpeername(socket, (struct sockaddr *)&addr, &addrlen) == -1)
		fatal_error("getpeername");
	return ntohs(addr.sin_port);
}
