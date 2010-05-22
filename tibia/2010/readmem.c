#define _GNU_SOURCE
#define _FILE_OFFSET_BITS 64

#include <assert.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>

#undef NDEBUG

int main(int argc, char **argv)
{
	int exitcode = EXIT_SUCCESS;
	assert(argc >= 3);
	pid_t const pid = atoi(argv[1]);
	assert(0 < pid);
	uintptr_t const address = strtoul(argv[2], NULL, 0);
	assert(ULONG_MAX != address);
	size_t const size = strtoul(argv[3], NULL, 0);
	assert(ULONG_MAX != size);

	char *mempath = NULL;
	assert(-1 != asprintf(&mempath, "/proc/%d/mem", pid));
	//fprintf(stderr, "memory file path: %s\n", mempath);
	char *outbuf = malloc(size);
	assert(NULL != outbuf);

	assert(!ptrace(PTRACE_ATTACH, pid, NULL, NULL));

	// deliver signals to the tracee until it receives SIGSTOP
	while (true) {
		int status = 0;
		assert(pid == waitpid(pid, &status, 0));
		assert(WIFSTOPPED(status));
		if (WSTOPSIG(status) == SIGSTOP) {
			break;
		}
		else {
			assert(!ptrace(PTRACE_CONT, pid, NULL, WSTOPSIG(status)));
		}
	}

	int memfd = open(mempath, O_RDONLY);
	assert(-1 != memfd);
	//fprintf(stderr, "preading 0x%zx bytes at %p\n", size, (void *)address);
	ssize_t readret = pread(memfd, outbuf, size, address);
	if (readret != size) {
		if (readret == -1) {
			perror("pread");
		}
		else {
			fprintf(stderr, "pread only read %zd bytes\n", readret);
		}
		exitcode = EXIT_FAILURE;
	}
	assert(!close(memfd));
	assert(!ptrace(PTRACE_DETACH, pid, NULL, 0));

	// byte count in nmemb to handle writes of length 0
	assert(size == fwrite(outbuf, 1, size, stdout));

	free(outbuf);
	free(mempath);

	return exitcode;
}
