#include <unistd.h>
#include <stdio.h>

int main ()
{
	while (1) {
		printf ("%ld\n", sysconf(_SC_CLK_TCK));
		sleep(1);
	}
	return 0;
}
