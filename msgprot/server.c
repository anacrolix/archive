#include "server.h"
#include "network.h"
#include "error.h"
#include "tcpmsg.h"

int server;
struct tcp_msg varsocks[FD_SETSIZE];

/* count of complete tcp_msgs received */
int msgcount;

/* returns highest fd for use in select */
int initFdSets(fd_set *readfds)
{
	FD_ZERO(readfds);
	FD_SET(server, readfds);
	int maxfd = server;
	for (int i = 0; i < FD_SETSIZE; i++) {
		if (tcp_msg_is_valid(&varsocks[i])) {
			int clientFd = varsocks[i].sockfd;
			FD_SET(clientFd, readfds);
			maxfd = clientFd > maxfd ? clientFd : maxfd;
		}
	}
	return maxfd;
}

int main()
{
	int i;
	debug("FD_SETSIZE=%d\n", FD_SETSIZE);
	/* initialize globals */
	for (i = 0; i < FD_SETSIZE; i++)
		varsocks[i] = tcp_msg_new();
	server = tcp_listen(1337, 50);
	msgcount = 0;
	/* main loop */
	while (1) {
		debug("\n");
		fd_set readfds;
		int maxFd = initFdSets(&readfds);
		debug("highest fd was %d\n", maxFd);
		int nfds;
		if ((nfds = select(maxFd + 1, &readfds, NULL, NULL, NULL)) == -1)
			fatal_error("select");
		debug("%d fds are ready\n", nfds);
		if (FD_ISSET(server, &readfds)) {
			nfds--;
			for (i = 0; i < FD_SETSIZE; i++) {
				if (!tcp_msg_is_valid(&varsocks[i]))
					break;
			}
			if (i < FD_SETSIZE) {
				int newsock = tcp_accept(server);
				tcp_msg_init(&varsocks[i], newsock, 0);
				debug("new connection from %s:%hu\n",
					tcp_peer_name(newsock),
					tcp_peer_port(newsock));
			} else {
				debug("cannot accept more connections!\n");
			}
		}
		if (nfds <= 0) continue;
		for (i = 0; i < FD_SETSIZE; i++) {
			if (!tcp_msg_is_valid(&varsocks[i])) continue;
			if (FD_ISSET(varsocks[i].sockfd, &readfds)) {
				nfds--;
				if (!tcp_msg_recv(&varsocks[i])) {
					tcp_close(varsocks[i].sockfd);
					varsocks[i] = tcp_msg_new();
				} else if (varsocks[i].data_done == varsocks[i].msg_size) {
					if (!strcasecmp(varsocks[i].data, "msg")) {
						printf("%s:%hu \"%s\"\n",
							tcp_peer_name(varsocks[i].sockfd),
							tcp_peer_port(varsocks[i].sockfd),
							(char *)varsocks[i].data + 4);
					} else if (!strcasecmp(varsocks[i].data, "exit")) {
						debug("close message received\n");
						tcp_close(varsocks[i].sockfd);
						varsocks[i] = tcp_msg_new();
					} else {
						debug("!! message not understood\n");
					}
					tcp_msg_init(&varsocks[i], varsocks[i].sockfd, 0);
					msgcount++;
				}
			}
		}
		printf("received %u messages so far\n", msgcount);
	}
	return EXIT_SUCCESS;
}
