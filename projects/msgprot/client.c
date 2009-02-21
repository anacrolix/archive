#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>

#include "error.h"
#include "network.h"
#include "tcpmsg.h"

int main(int argc, char *argv[])
{
	char *peerHost = "localhost";
	if (argc == 2) peerHost = argv[1];
	debug("peerHost == \"%s\"\n", peerHost);
	int sock = tcp_connect("localhost", 1337);
	char zomgbuf[1024];
	strcpy(zomgbuf, "msg");
	while (1) {
		debug("\n");
		struct tcp_msg tm = tcp_msg_new();
		size_t msgsize;
		printf("enter message: ");
		if (EOF == scanf("%1023s", zomgbuf + 4)) {
			msgsize = strlen("exit") + 1;
			tcp_msg_init(&tm, sock, msgsize);
			tcp_msg_send(&tm, "exit", msgsize);
			tcp_msg_clean(&tm);
			break;
		} else {
			msgsize = strlen(zomgbuf + 4) + 5;
			tcp_msg_init(&tm, sock, msgsize);
			for (int i = 0; i < msgsize; i++) {
				//sleep(1);
				tcp_msg_send(&tm, zomgbuf + i, 1);
				debug("send the \'%c\'\n", *(zomgbuf + i));
			}
			tcp_msg_clean(&tm);
		}
	}
	tcp_close(sock);
	return EXIT_SUCCESS;
}
