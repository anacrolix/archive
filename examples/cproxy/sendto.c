#include <winsock.h>
#include <stdio.h>

#define HOST_PORT 6666
//#define REPLY_MSG "HIHO NOOBS"

int main(int argc, char *argv[]) {
	if (argc < 3) {
		printf("Not enough arguments supplied.\nsendto [hostip] [msg]\n");
		goto Error;
	}
	printf("Attempt to send message \"%s\" to \"%s\"\n", argv[2], argv[1]);
	system("pause");

	printf("\nInitializing Winsock.\n");
	WSADATA wsaData;
	if (WSAStartup(MAKEWORD(1, 1), &wsaData) != 0) {
		printf("Winsock failed to start.\n");
		goto Error;
	}

	printf("Opening UDP/IP socket.\n");
	SOCKET sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (sock == INVALID_SOCKET) {
		printf("Failed to open a socket.\n");
		//printf("Error: %ld\n", WSAGetLastError());
		goto Error;
	}

	SOCKADDR_IN addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr(argv[1]);
	addr.sin_port = htons(HOST_PORT);

	/*
	printf("Binding socket to %x:%d\n", ntohl(addr.sin_addr.s_addr), ntohs(addr.sin_port));
	int res = bind(sock, (struct sockaddr *)&addr, sizeof(addr));
	if (res == SOCKET_ERROR) {
		printf("bind() failed.\n");
		exit(1);
	}*/
	/*
	char buffer[2048];
	int addrLen, lenRecv, lenSent;
	printf("Waiting for message\n");
	do {
		lenRecv = recvfrom(sock, buffer, sizeof(buffer), 0, (struct sockaddr *)&addr, &addrLen);
	} while (lenRecv < 0);
	printf("Received packet from: %x:%d\n", addr.sin_addr.s_addr, addr.sin_port);
	buffer[lenRecv] = 0;
	printf("\"%s\n\"", buffer);
	strcpy(buffer, REPLY_MSG);
	*/

	printf("Attempting to send packet.\n");
	int bytesSent;
	bytesSent = sendto(sock, argv[2], strlen(argv[2]), 0, (struct sockaddr *)&addr, sizeof(addr));
	if (bytesSent < 0 || bytesSent < (int)strlen(argv[2])) {
		printf("Send failed.\n");
		goto Error;
	}
	printf("Packet sent successfully!\n");

	closesocket(sock);
	return 0;

Error:
	printf("Terminating program.\n");
	closesocket(sock);
	system("pause");
	return 1;
}