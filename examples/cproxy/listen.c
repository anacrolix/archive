#include <winsock.h>
#include <stdio.h>

#define LISTEN_PORT 6666
#define REPLY_MSG "HIHO NOOBS"

int main(int argc, char *argv[]) {
	printf("Initializing Winsock.\n");
	WSADATA wsaData;
	if (WSAStartup(MAKEWORD(1, 1), &wsaData) != 0) {
		printf("WSAStartup failed.\n");
		goto Error;
	}

	printf("Opening socket\n");
	SOCKET sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (sock == INVALID_SOCKET) {
		printf("Error: %ld\n", WSAGetLastError());
		exit(1);
	}

	printf("Getting listen address\n");
	SOCKADDR_IN addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = htons(LISTEN_PORT);

	printf("Binding socket to %s:%d\n", inet_ntoa(addr.sin_addr), ntohs(addr.sin_port));
	int res = bind(sock, (struct sockaddr *)&addr, sizeof(addr));
	if (res == SOCKET_ERROR) {
		printf("bind() failed.\n");
		exit(1);
	}

	printf("Waiting for messages\n");
	while (1) {
		char buffer[2048];
		int addrLen, lenRecv, lenSent;
		do {
			lenRecv = recvfrom(sock, buffer, sizeof(buffer), 0, (struct sockaddr *)&addr, &addrLen);
		} while (lenRecv < 0);
		printf("Received packet from: %s:%d\n", inet_ntoa(addr.sin_addr), addr.sin_port);
		buffer[lenRecv] = 0;
		printf("\"%s\"\n", buffer);
		strcpy(buffer, REPLY_MSG);
		lenSent = sendto(sock, buffer, strlen(buffer), 0, (struct sockaddr *)&addr, addrLen);
		if (lenSent < 0) {
			printf("Couldn't send packet\n");
			goto Error;
		}
	}
	closesocket(sock);
	return 0;
Error:
	printf("Terminating program.\n");
	closesocket(sock);
	system("pause");
	return 1;
}