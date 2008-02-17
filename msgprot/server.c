#include <unistd.h>
#include <sys/socket.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <stdlib.h>

#include "network.h"
#include "error.h"
#include "tcpmsg.h"

int main ()
{
	int server = tcp_listen(1337, 1);
	int client = tcp_accept(server);
	close(server);
	printf("accepted connection from %s:%hu\n",
		socket_peer_name(client), socket_peer_port(client));
	for (;;) {
		struct tcp_msg tm = tcp_msg_init(client, 0);
		tcp_msg_recv(&tm);
		while (tm.data_done != tm.msg_size)
			tcp_msg_recv(&tm);
		printf("received %d bytes\nmessage reads: %s\n", tm.msg_size, (char*)tm.data);
		tcp_msg_destroy(&tm);
	}
	// accept and start message grabbing until a message reads exit
	return EXIT_SUCCESS;
}

