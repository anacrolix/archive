#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
	printf("gethostid() == %lx\n", gethostid());
	if (-1 == nice(20)) {
		perror("nice()");
		return EXIT_FAILURE;
	}
	while (1) {
		sleep(1);
	}
	return EXIT_SUCCESS;
}
