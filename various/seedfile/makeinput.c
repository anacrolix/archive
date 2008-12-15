#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	/* process arguments */
	char *endptr;
	errno = 0;
	long int seed = strtol(argv[1], &endptr, 0);
	if (errno || *endptr) goto fail;
	size_t n = strtoul(argv[2], NULL, 0);
	if (errno || *endptr) goto fail;

	/* generate output */
	srand48(seed);
	for ( ; n > 0; n -= sizeof(long int)) {
		long int m = mrand48();
		if (fwrite(&m, (sizeof(m) < n) ? sizeof(m) : n, 1, stdout) != 1) goto fail;
	}

	return EXIT_SUCCESS;
fail:
	fprintf(stderr, "Usage: %s <seed> <number output bytes>\n", argv[0]);
	return EXIT_FAILURE;
}
