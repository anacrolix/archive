#include "error.h"
#include "network.h"
#include "tcpmsg.h"

struct tcp_msg tcp_msg_new(int sockfd, uint32_t size)
{
	struct tcp_msg tm = {
		.sockfd = sockfd,
		.size = size,
		.done = 0,
		.senthdr = 0
	};
	return tm;
}

void tcp_msg_send_hdr(struct tcp_msg *tm)
{
	err_debug("sending message header size=%u\n", tm->size);
	uint32_t netsize = htonl(tm->size);
	tcp_write(tm->sockfd, &netsize, sizeof(netsize));
	tm->senthdr = 1;
}

void tcp_msg_send_data(struct tcp_msg *tm, void *data, size_t len)
{
	if (!tm->senthdr) err_fatal("header not sent yet");
	if (tm->done + len > tm->size) err_fatal("message will overflow");
	tcp_write(tm->sockfd, data, len);
	tm->done += len;
}

int tcp_msg_done(struct tcp_msg *tm)
{
	return (tm->done == tm->size);
}
