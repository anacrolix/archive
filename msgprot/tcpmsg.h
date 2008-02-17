#ifndef tcpmsg_h
#define tcpmsg_h

struct tcp_msg {
	int sockfd;
	uint32_t size;
	uint32_t done;
	int senthdr;
};

struct tcp_msg tcp_msg_new(int sockfd, uint32_t size);
void tcp_msg_send_hdr(struct tcp_msg *tm);
void tcp_msg_send_data(struct tcp_msg *tm, void *data, size_t len);
int tcp_msg_done(struct tcp_msg *tm);

#endif
