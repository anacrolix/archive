#define _GNU_SOURCE

#include <sys/stat.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>

#ifdef NDEBUG
#define verify(x) (x)
#else
#define verify(x) assert((x))
#endif

void revbuf(char *dst, char const *src, size_t len)
{
	for (dst += len - 1; len-- > 0; *dst-- = *src++);
}

int store_fd(int in_fd)
{
	char path[] = "XXXXXX";
	int temp_fd = mkstemp(path);
	assert(-1 != temp_fd);
	fprintf(stderr, "using temporary file: %s, chunk size: %d\n", path, BUFSIZ);
	verify(!unlink(path));
	while (true) {
		char buf[BUFSIZ];
		ssize_t bytes_read = read(in_fd, buf, sizeof(buf));
		if (!bytes_read) break;
		assert(bytes_read != -1);
		verify(write(temp_fd, buf, bytes_read) == bytes_read);
	}
	return temp_fd;
}

void do_thingy(int fdin, int fdout, off_t inoff, size_t count)
{
	char bufin[count], bufout[count];
	verify(lseek(fdin, inoff, SEEK_SET) == inoff);
	verify(read(fdin, bufin, count) == count);
	revbuf(bufout, bufin, count);
	verify(write(fdout, bufout, count) == count);
}

int main()
{
	struct stat stat_;
	int fd = STDIN_FILENO;

	if (isatty(fd))
		fprintf(stderr, "input is attached to a terminal\n");

	if (isatty(STDOUT_FILENO)) {
		fprintf(stderr, "error: stdout is attached to a terminal\n");
		return EXIT_FAILURE;
	}

	verify(!fstat(fd, &stat_));
	if (S_ISREG(stat_.st_mode)) {
		// this is good!
	} else if (S_ISFIFO(stat_.st_mode)) {
		int new_fd = store_fd(fd);
		verify(-1 != dup2(new_fd, fd));
		verify(!close(new_fd));
		verify(!fstat(fd, &stat_));
		assert(S_ISREG(stat_.st_mode));
	} else {
		fprintf(stderr, "stdin is unhandled file mode: %o\n", stat_.st_mode);
		return EXIT_FAILURE;
	}

	fprintf(stderr, "reversing %ld bytes, chunk size: %d\n", stat_.st_size, BUFSIZ);

	for (off_t inoff = stat_.st_size - BUFSIZ; inoff >= 0; inoff -= BUFSIZ)
		do_thingy(fd, STDOUT_FILENO, inoff, BUFSIZ);
	do_thingy(fd, STDOUT_FILENO, 0, stat_.st_size % BUFSIZ);

	return EXIT_SUCCESS;
}
