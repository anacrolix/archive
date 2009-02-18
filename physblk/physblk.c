#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <linux/fs.h>
#include <errno.h>
#include <error.h>
#include "../eruutil/debug.h"

int main(int argc, char *argv[])
{
	int fd = open(argv[1], O_RDONLY);
	if (fd < 0) fatal(errno, "open()");
	struct stat sb;
	if (fstat(fd, &sb)) fatal(errno, "fstat()");
	trace("%u", sb.st_blksize);
	trace("%u", sb.st_blocks);
	trace("%u", sb.st_blocks / (sb.st_blksize / 512));
	for (int i = 0; i < sb.st_blocks / (sb.st_blksize / 512); i++) {
		int logblk = i;
		errno = 0;
		if (ioctl(fd, FIBMAP, &logblk) == -1) fatal(errno, "ioctl()");
		if (errno != 0) fatal(errno, "errno changed!");
		if (logblk == 0) continue;
		printf("(%u, %u)\n", i, logblk);
	}
	return 0;
}
