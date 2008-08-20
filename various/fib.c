#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	uintmax_t a = 0, b = 1, n = atoi(argv[1]);
	while (--n) {
		uintmax_t c = a + b;
		a = b;
		b = c;
	}
	printf("%llu\n", b);
	return EXIT_SUCCESS;
}
