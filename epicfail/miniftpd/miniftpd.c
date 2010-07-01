#include "miniftpd.h"

int main()
{
	// create the socket
	int servsock = socket(AF_INET, SOCK_STREAM, 0);
	require(servsock != -1);

	// set reusable
	int optval = 1;
	setsockopt(servsock, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval));

	// bind it
	struct sockaddr_in bindaddr;
	memset(&bindaddr, 0, sizeof(bindaddr));
	bindaddr.sin_family = AF_INET;
	bindaddr.sin_port = htons(1337);
	bindaddr.sin_addr.s_addr = INADDR_ANY;
	require(0 == bind(servsock, (struct sockaddr *)&bindaddr, sizeof(bindaddr)));

	// log local address
	struct sockaddr servaddr;
	socklen_t addrlen = sizeof(servaddr);
	require(0 == getsockname(servsock, &servaddr, &addrlen));
	assert(addrlen <= sizeof(servaddr));
	char hostbuf[NI_MAXHOST], servbuf[NI_MAXSERV];
	require(0 == getnameinfo(&servaddr, addrlen, hostbuf, sizeof(hostbuf), servbuf, sizeof(hostbuf), NI_NUMERICHOST | NI_NUMERICSERV));
	char *sockname = sockaddr_to_numeric_string(&servaddr, addrlen);
	my_log("Listening on %s", sockname);
	free(sockname);

	// listen
	require(0 == listen(servsock, SOMAXCONN));

	while (true)
	{
		struct sockaddr_in peeraddr;
		socklen_t palen = sizeof(peeraddr);
		int peersock = accept(servsock, (struct sockaddr *)&peeraddr, &palen);
		if (peersock != -1)
		{
			char *peername = sockaddr_to_numeric_string(
					(struct sockaddr *)&peeraddr, palen);
			my_log("Connection from %s", peername);
			free(peername);

			pid_t pid = fork();
			expect(pid != -1);
			if (pid == 0) {
				expect(0 == close(servsock));
				expect(3 == dup2(peersock, 3));
				execl("serverpi", "serverpi", NULL);
				error(EXIT_FAILURE, 0, "execl() into server protocol interpreter");
			} else {
				expect(0 == close(peersock));
			}
		}
	}
	return EXIT_SUCCESS;
}
