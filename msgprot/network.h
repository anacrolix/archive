#ifndef network_h
#define network_h

int tcp_connect(char *name, unsigned short int port);
int tcp_listen(unsigned short int port, unsigned int backlog);
int tcp_accept(int socket);
char *tcp_peer_host(int socket);
unsigned short int tcp_peer_port(int socket);

#endif
