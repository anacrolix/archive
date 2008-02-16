#include "error.h"
#include "network.h"

#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>

int main()
{
	int s = tcp_connect("localhost", 1337);
	char zomgbuf[1024];
	for (;;) {
		printf("enter message: ");
		scanf("%s", zomgbuf);
		size_t msg_len = strlen(zomgbuf);
		printf("message is length %d\n", msg_len);
		ssize_t nmsg_len = htonl(msg_len);
		if (send(s, &nmsg_len, sizeof(nmsg_len), 0) == -1)
			fatal_error("send");
		for (int i = 0; i < msg_len; i++) {
			sleep(1);			
			if (send(s, zomgbuf+i, 1, 0) == -1)
				fatal_error("send");
			printf("send the \'%c\'\n", *(zomgbuf+i));
		}
	}
	return 0;
}
