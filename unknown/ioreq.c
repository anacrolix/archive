#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/cdrom.h>

int main(int argc, char *argv[])
{
	int fd = open(argv[1], O_RDONLY /*| O_NONBLOCK*/);
	if (fd < 0) {
		perror("open()");
		return 1;
	}
	assert(ioctl(fd, CDROMEJECT, 0));
	close(fd);
	return 0;
}
