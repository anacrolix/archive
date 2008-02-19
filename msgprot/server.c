#include "server.h"
#include "network.h"
#include "error.h"
#include "tcpmsg.h"

const int varsocks_limit = sizeof(fd_set) / sizeof(int);

int main()
{
	int i;
	debug("varsocks_limit=%d\n", varsocks_limit);
	debug("FD_SETSIZE=%d\n", FD_SETSIZE);
	struct tcp_msg varsocks[varsocks_limit];
	for (i = 0; i < varsocks_limit; i++)
		varsocks[i] = tcp_msg_new();
	int server = tcp_listen(1337, 5);
	while (1) {
		fd_set readfds;
		FD_ZERO(&readfds);
		FD_SET(server, &readfds);
		int maxfd = server;
		for (i = 0; i < varsocks_limit; i++) {
			if (tcp_msg_is_valid(&varsocks[i])) {
				FD_SET(varsocks[i].sockfd, &readfds);
				if (varsocks[i].sockfd > maxfd) {
					maxfd = varsocks[i].sockfd;
				}
			}
		}
		debug("highest fd was %d\n", maxfd);
		int nfds;
		if ((nfds = select(maxfd + 1, &readfds, NULL, NULL, NULL)) == -1)
			fatal_error("select");
		debug("select returned %d fds\n", nfds);
		if (FD_ISSET(server, &readfds)) {
			for (i = 0; i < varsocks_limit; i++) {
				if (!tcp_msg_is_valid(&varsocks[i]))
					break;
			}
			if (i < varsocks_limit) {
				int newsock = tcp_accept(server);
				tcp_msg_init(&varsocks[i], newsock, 0);
				debug("new connection from %s:%hu\n",
					tcp_peer_name(newsock),
					tcp_peer_port(newsock));
			} else {
				debug("cannot accept more connections!\n");
			}
		}
		//if (nfds < 2) continue;
		for (i = 0; i < varsocks_limit; i++) {
			if (!tcp_msg_is_valid(&varsocks[i])) continue;
			if (FD_ISSET(varsocks[i].sockfd, &readfds)) {
				if (!tcp_msg_recv(&varsocks[i])) {
					tcp_close(varsocks[i].sockfd);
					varsocks[i] = tcp_msg_new();
				} else if (varsocks[i].data_done == varsocks[i].msg_size) {
					printf("message received: %s\n",
						(char *)varsocks[i].data);
					tcp_msg_init(&varsocks[i], varsocks[i].sockfd, 0);
				}
			}
		}
	}
	return EXIT_SUCCESS;
}
