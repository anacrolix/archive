#include <unistd.h>
#include <sys/socket.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <stdlib.h>

#include "network.h"
#include "error.h"

int main ()
{
	err_debug("im %d y.o.\n", 22);
	int server = tcp_listen(1337, 1);
	int client = tcp_accept(server);
	printf("accepted connection from %s:%hu\n",
		tcp_peer_host(client), tcp_peer_port(client));
	for (;;) {
		char msg_size[sizeof(ssize_t)];
		ssize_t received = 0, bytes;
		while (received != sizeof msg_size) {
			bytes = recv(client, msg_size + received, sizeof(msg_size) - received, 0);
			if (bytes < 0)
				err_fatal("recv");
			else if (bytes == 0) {
				puts("socket closed");
				close(client);
				return 0;
			} else
				received += bytes;
		}
		received = 0;
		uint32_t size = ntohl(*((uint32_t*)msg_size));
		printf("next message is %d bytes long\n", size);
		char *zomgbuf = malloc(size);
		while (received != size) {
			bytes = recv(client, zomgbuf + received, size - received, 0);
			if (bytes == -1) {
				err_fatal("recv");
			} else if (bytes == 0) {
				puts("socked died in the ass");
				close(client);
				return 0;
			} else {
				received += bytes;
			}
		}
		zomgbuf[received] = '\0';
		printf("received %d bytes\nmessage reads: %s\n", received, zomgbuf);
		free(zomgbuf);
	}
	// accept and start message grabbing until a message reads exit
	return 0;
}

