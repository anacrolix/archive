#include <unistd.h>
#include <stdio.h>
#include <signal.h>

void sighandler(int signo)
{
	switch (signo) {
		case SIGINT:
		case SIGTERM:
		printf("\b\bno don't leave me :(\n");
		break;
		default:
		break;
	}
}

int main()
{
	signal(SIGCONT, sighandler);
	signal(SIGINT, sighandler);
	signal(SIGTERM, sighandler);
	for (;;) {
		pause();
		printf("hi\n");
	}
	return 0;
}
