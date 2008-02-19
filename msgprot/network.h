#ifndef network_h
#define network_h

#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

int tcp_connect(char *name, unsigned short int port);
int tcp_listen(unsigned short int port, unsigned int backlog);
int tcp_accept(int socket);
void tcp_close(int sockfd);

ssize_t tcp_write(int fd, const void *buf, size_t len);
ssize_t tcp_read(int sockfd, void *buf, size_t len);

char *tcp_peer_name(int socket);
unsigned short int tcp_peer_port(int socket);

#endif
