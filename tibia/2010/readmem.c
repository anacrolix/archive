#include "botutil.h"

/*
Returns 0: success, 1: general failure, 2: argument issue, 3: retry
*/
int main(int argc, char **argv)
{
	/* parse arguments */

	if (argc < 4)
	{
		fprintf(stderr, "Missing arguments\n");
		return 2;
	}

	pid_t const pid = atoi(argv[1]);
	uintptr_t const address = strtoul(argv[2], NULL, 0);
	size_t const size = strtoul(argv[3], NULL, 0);

	if (pid <= 0 || address == ULONG_MAX || size == ULONG_MAX)
	{
		fprintf(stderr, "Invalid arguments\n");
		return 2;
	}

	/* prepare for memory reads */

	char *mempath = NULL;
	verify(-1 != asprintf(&mempath, "/proc/%d/mem", pid));
	char *outbuf = malloc(size);
	assert(outbuf != NULL);

	/* attach to target process */

	// attach or exit with code 3 to indicate try again
	if (0 != ptrace(PTRACE_ATTACH, pid, NULL, NULL))
	{
		int errattch = errno;
		if (errattch == EPERM)
		{
			pid_t tracer = get_tracer_pid(pid);
			if (tracer != 0)
			{
				fprintf(stderr, "Process %d is currently attached\n", tracer);
				return 3;
			}
		}
		error(3, errattch, "ptrace(PTRACE_ATTACH)");
	}

	wait_until_tracee_stops(pid);

	int memfd = open(mempath, O_RDONLY);
	assert(memfd != -1);

	// read bytes from the tracee's memory
	verify(size == pread(memfd, outbuf, size, address));

	verify(!close(memfd));
	verify(!ptrace(PTRACE_DETACH, pid, NULL, 0));

	// write requested memory region to stdout
	// byte count in nmemb to handle writes of length 0
	verify(size == fwrite(outbuf, 1, size, stdout));

	free(outbuf);
	free(mempath);

	return 0;
}
