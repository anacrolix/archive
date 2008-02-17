#ifndef tcpmsg_h
#define tcpmsg_h

#include <stdlib.h>

typedef uint32_t tmsize_t;

enum tmio_t {
	TM_SEND,
	TM_RECV
};

struct tcp_msg {
	int sockfd;
	enum tmio_t iotype;
	tmsize_t msg_size;
	tmsize_t data_done;
	tmsize_t hdr_done;
	tmsize_t hdr;
	void *data;
};

struct tcp_msg tcp_msg_init(int sockfd, tmsize_t size);
ssize_t tcp_msg_send(struct tcp_msg *tm, void *data, size_t len);
void tcp_msg_recv(struct tcp_msg *tm);
void tcp_msg_destroy(struct tcp_msg *tm);

#endif
