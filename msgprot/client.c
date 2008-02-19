#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>

#include "error.h"
#include "network.h"
#include "tcpmsg.h"

int main()
{
	int sock = tcp_connect("localhost", 1337);
	char zomgbuf[1024];
	while (1) {
		//char zomgbuf[1024];
		printf("enter message: ");
		if (EOF == scanf("%1023s", zomgbuf)) break;
		size_t msgsize = strlen(zomgbuf);
		struct tcp_msg tm = tcp_msg_new();
		tcp_msg_init(&tm, sock, msgsize);
		for (int i = 0; i < msgsize; i++) {
			sleep(1);
			tcp_msg_send(&tm, zomgbuf + i, 1);
			printf("send the \'%c\'\n", *(zomgbuf + i));
		}
		tcp_msg_clean(&tm);
	}
	tcp_close(sock);
	/*
	int sock = tcp_connect("localhost", 1337);
	char zomgbuf[1024];
	for (;;) {
		printf("enter message: ");
		scanf("%s", zomgbuf);
		size_t msg_len = strlen(zomgbuf);
		struct tcp_msg tm = tcp_msg_init(sock, msg_len);
		for (int i = 0; i < msg_len; i++) {
			sleep(1);
			tcp_msg_send(&tm, zomgbuf + i, 1);
			printf("send the \'%c\'\n", *(zomgbuf+i));
		}
		tcp_msg_destroy(&tm);
	}
	*/
	return EXIT_SUCCESS;
}
