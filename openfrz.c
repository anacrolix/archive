#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "eruutil/erudebug.h"
#include <unistd.h>
#include <sys/mman.h>
#include <assert.h>

int main(int argc, char *argv[])
{
	int fd = open(argv[1], O_RDONLY);
	dump(fd, "%d");
	struct stat stat;
	fstat(fd, &stat);
	dump(stat.st_size, "%u");
	void *blah = mmap(NULL, stat.st_size, PROT_READ, MAP_SHARED, fd, 0);
	assert(blah != MAP_FAILED);
	dump(*(char *)(blah + 3), "%c");
	sleep(100);
	return 0;
}
