#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>

#include "error.h"
#include "network.h"

int main()
{
	int sock = tcp_connect("localhost", 1337);
	char zomgbuf[1024];
	for (;;) {
		printf("enter message: ");
		scanf("%s", zomgbuf);
		size_t msg_len = strlen(zomgbuf);
		printf("message is length %d\n", msg_len);
		ssize_t nmsg_len = htonl(msg_len);
		tcp_write(sock, &nmsg_len, sizeof(nmsg_len));
		for (int i = 0; i < msg_len; i++) {
			sleep(1);			
			tcp_write(sock, zomgbuf + i, 1);
			printf("send the \'%c\'\n", *(zomgbuf+i));
		}
	}
	return 0;
}
