#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <string.h>

#define handle_error(msg) {perror(msg); exit(EXIT_FAILURE);}

int main()
{
	int serverSocket = socket(PF_INET, SOCK_STREAM, 0);
	if (serverSocket == -1) handle_error("socket");
	
	struct sockaddr_in serverAddr;
	memset(&serverAddr, 0, sizeof serverAddr);
	serverAddr.sin_family = PF_INET;
	serverAddr.sin_port = htons(1337);
	serverAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	
	if (bind(serverSocket, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) == -1)
		handle_error("bind");
	
	if (listen(serverSocket, 5) == -1)
		handle_error("listen");
		
	struct sockaddr_in peerAddr = {0};
	socklen_t peerAddrLen = sizeof peerAddr;
	if (accept(serverSocket, (struct sockaddr *)&peerAddr, &peerAddrLen) == -1)
		handle_error("accept");
	puts("received connection from: ");
	puts(inet_ntoa(peerAddr.sin_addr));
	
	return EXIT_SUCCESS;
}
