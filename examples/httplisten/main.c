#include <stdio.h>
#include <stdlib.h>
#include <winsock2.h>
//#include <ws2tcpip.h>


int main(int argc, char *argv[])
{
  WSADATA wsaData;
  int iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
  if (iResult != 0) {
		printf("WSAStartup failed: %d\n", iResult);
    return 1;
  }
	int sockfd;
	struct sockaddr_in addrLocal, addrRemote;
	int sin_size;

	if ((sockfd = socket(PF_INET, SOCK_STREAM, 0)) == -1) {
		perror("socket");
		exit(1);
	}

	addrLocal.sin_family = AF_INET;
	addrLocal.sin_port = htons(80);
	addrLocal.sin_addr.s_addr = INADDR_ANY;
	
	if (bind(sockfd, (struct sockaddr *)&addrLocal, sizeof(struct sockaddr)) == -1) {
		perror("bind");
		exit(1);
	}
	
	if (listen(sockfd, 1) == -1) {
		perror("listen");
		exit(1);
	}
	
	int newSockFd, recvBytes;
	while (1) {
		sin_size = sizeof(struct sockaddr_in);
		if ((newSockFd = accept(sockfd, (struct sockaddr *)&addrRemote, &sin_size)) == -1) {
			perror("accept");
			continue;
		}
		printf("server: connection established from %s\n", inet_ntoa(addrRemote.sin_addr));
		#define PAGE "HTTP/1.1 200 OK\nContent-Length: 28\nContent-type: text/html\n\n<html><body>hi</body></html>"
		send(newSockFd, PAGE, strlen(PAGE), 0);
		#undef PAGE 
		close(newSockFd);
		continue;
		while (1) {
			char bufRecv[100];
			if ((recvBytes = recv(newSockFd, bufRecv, sizeof(bufRecv), 0)) <= 0) {
				if (recvBytes == 0) {
					printf("\nserver: %s hangup\n", inet_ntoa(addrRemote.sin_addr));
				} else {
					perror("recv");
				}
				close(newSockFd);
				break;
			} else {
				bufRecv[recvBytes] = '\0';
				printf("%s", bufRecv);
			}
			//close(newSockFd);
		}
	}
  system("PAUSE");	
  return 0;
}
