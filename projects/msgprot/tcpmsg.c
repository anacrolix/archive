#include "tcpmsg.h"
#include "error.h"
#include "network.h"

struct tcp_msg tcp_msg_new()
{
	struct tcp_msg ret = {
		.sockfd = -1
	};
	return ret;
}

void tcp_msg_init(struct tcp_msg *tm, int sockfd, tmsize_t size)
{
	struct tcp_msg newtm = {
		.sockfd = sockfd,
		.iotype = size ? TM_SEND : TM_RECV,
		.msg_size = size,
		.data_done = 0,
		.hdr_done = 0,
		.hdr = size ? htonl(size) : 0,
		.data = NULL,
	};
	*tm = newtm;
}

ssize_t tcp_msg_send(struct tcp_msg *tm, void *data, size_t len)
{
	assert(tm->iotype == TM_SEND);
	ssize_t sent;
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
		assert(tm->data_done + len <= tm->msg_size);
		sent = tcp_write(tm->sockfd, data, len);
		tm->data_done += sent;
	}
	return sent;
}

ssize_t tcp_msg_recv(struct tcp_msg *tm)
{
	assert(tm->iotype == TM_RECV);
	ssize_t recvcnt;
	// recv header if it's not already set
	if (tm->hdr_done != sizeof(tmsize_t)) {
		recvcnt = tcp_read(
			tm->sockfd,
			&(tm->hdr) + tm->hdr_done,
			sizeof(tmsize_t) - tm->hdr_done);
		assert(recvcnt != -1);
		if (recvcnt == 0) return recvcnt;
		tm->hdr_done += recvcnt;
		recvcnt = 0;
		if (tm->hdr_done == sizeof(tmsize_t)) {
			tm->msg_size = ntohl(tm->hdr);
			tm->data = malloc(tm->msg_size);
			debug("header received, size = %lu\n", tm->msg_size);
		}
	}
	// receive as much data as possible
	if (tm->hdr_done == sizeof(tm->msg_size)) {
		recvcnt = tcp_read(
			tm->sockfd,
			tm->data + tm->data_done,
			tm->msg_size - tm->data_done);
		tm->data_done += recvcnt;
		debug("received %d bytes, %lu remaining\n",
			recvcnt, tm->msg_size - tm->data_done);
	}
	return recvcnt;
}

void tcp_msg_clean(struct tcp_msg *tm)
{
	assert(tcp_msg_is_valid(tm));
	if (tm->data) free(tm->data);
	*tm = tcp_msg_new();
}

int tcp_msg_is_valid(struct tcp_msg *tm)
{
	return (tm->sockfd != -1);
}
