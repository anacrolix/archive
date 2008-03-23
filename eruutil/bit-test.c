#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <error.h>
#include <sys/mman.h>
#include <limits.h>
#include <sys/stat.h>
#include <assert.h>
#include <stdio.h>
#include "erudebug.h"
#include "bit.h"

#define usage()

int main(int argc, char *argv[])
{
	int retVal = EXIT_FAILURE;
	char *fdmap = MAP_FAILED;
	int fd = -1;

	if (argc != 2) goto done;

	fd = open(argv[1], O_RDONLY);
	if (fd == -1) {warn(errno, "open()"); goto done;}

	struct stat fdstat;
	if (fstat(fd, &fdstat)) {warn(errno, "open()"); goto done;}

	fdmap = mmap(NULL, fdstat.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (fdmap == MAP_FAILED) {warn(errno, "mmap()"); goto done;}

	char *endbyte = fdmap + fdstat.st_size;
	long longbit = sysconf(_SC_LONG_BIT);
	if (longbit == -1) {warn(errno, "sysconf()"); goto done;}
	assert(longbit == 32);
	unsigned bits = 0;
	for (int i = 0; i < 100; i++) {
		struct bitptr bp;
		bit_init(&bp, fdmap);
		while (bp.byte < endbyte) {
			bit_read(&bp, bits % longbit);
			bits++;
		}
		bit_finish(&fd);
	}

	retVal = EXIT_SUCCESS;
done:
	if (fdmap != MAP_FAILED && munmap(fdmap, fdstat.st_size)) {
		fatal(errno, "munmap()");
	}

	if (fd != -1 && close(fd)) {
		fatal(errno, "close()");
	}

	return retVal;
}
