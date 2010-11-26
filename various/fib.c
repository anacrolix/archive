#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

uint64_t *fib(int n)
{
    uint64_t *retval = malloc(n * sizeof(*retval));
    uint64_t a = 0, b = 1;
    for (int i = 0; i < n; ++i) {
        retval[i] = a;
		uint64_t c = a + b;
		a = b;
		b = c;
	}
    return retval;
}

int main(int argc, char *argv[])
{
    if (argc != 2)
        return 2;
    char *endptr;
    errno = 0;
    int count = strtol(argv[1], &endptr, 10);
    if (errno)
        return 2;
    uint64_t *blah = fib(count);
    putchar('[');
    for (int i = 0; i < count; ++i) {
        if (i) {
            putchar(' ');
        }
        printf("%llu", blah[i]);
    }
    puts("]");
	return EXIT_SUCCESS;
}

