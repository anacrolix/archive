#include "error.h"
#include "network.h"
#include "tcpmsg.h"

struct tcp_msg tcp_msg_init(int sockfd, tmsize_t size)
{
	struct tcp_msg tm = {
		.sockfd = sockfd,
		.iotype = size ? TM_SEND : TM_RECV,
		.msg_size = size,
		.data_done = 0,
		.hdr_done = 0,
		.hdr = size ? htonl(size) : 0,
		.data = NULL,
	};
	return tm;
}

ssize_t tcp_msg_send(struct tcp_msg *tm, void *data, size_t len)
{
	ssize_t sent;
	// check message is send type
	if (tm->iotype != TM_SEND) {
		debug("tcp message is not of send type\n");
		return -1;
	}
	// send header if it's not already sent
	if (tm->hdr_done != sizeof(tmsize_t)) {
		sent = tcp_write(
			tm->sockfd,
			&tm->hdr,
			sizeof(tmsize_t) - tm->hdr_done);
		tm->hdr_done += sent;
		sent = 0;
	}
	// send as much data as possible
	if (tm->hdr_done == sizeof(tm->msg_size)) {
		if (tm->data_done + len > tm->msg_size) {
			debug("data will overflow message\n");
			return -1;
		} else {
			sent = tcp_write(tm->sockfd, data, len);
			tm->data_done += sent;
		}
	}
	return sent;
}

void tcp_msg_recv(struct tcp_msg *tm)
{
	ssize_t recvcnt;
	// check message is recv type
	if (tm->iotype != TM_RECV)
		fatal("tcp message is not of recv type\n");
	// recv header if it's not already set
	if (tm->hdr_done != sizeof(tmsize_t)) {
		recvcnt = tcp_read(
			tm->sockfd,
			&tm->hdr + tm->hdr_done,
			sizeof(tmsize_t) - tm->hdr_done);
		tm->hdr_done += recvcnt;
		recvcnt = 0;
		if (tm->hdr_done == sizeof(tmsize_t)) {
			tm->msg_size = ntohl(tm->hdr);
			tm->data = malloc(tm->msg_size);
		}
	}
	// receive as much data as possible
	if (tm->hdr_done == sizeof(tm->msg_size)) {
		recvcnt = tcp_read(
			tm->sockfd,
			tm->data + tm->data_done,
			tm->msg_size - tm->data_done);
		tm->data_done += recvcnt;
	}
}

void tcp_msg_destroy(struct tcp_msg *tm)
{
	if (tm->data) free(tm->data);
	tm->data = NULL;
}
