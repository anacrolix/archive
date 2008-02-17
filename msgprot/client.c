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
	for (;;) {
		printf("enter message: ");
		scanf("%s", zomgbuf);
		size_t msg_len = strlen(zomgbuf);
		struct tcp_msg tm = tcp_msg_new(sock, msg_len);
		tcp_msg_send_hdr(&tm);
		for (int i = 0; i < msg_len; i++) {
			sleep(1);		
			tcp_msg_send_data(&tm, zomgbuf + i, 1);	
			printf("send the \'%c\'\n", *(zomgbuf+i));
		}
	}
	return 0;
}
