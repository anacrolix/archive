#include "matt/debug.h"
#include "matt/procmaps.h"
#include <stdio.h>
#include <error.h>
#include <errno.h>
#include <stdlib.h>
#include <assert.h>

/// prints correct program usage and exits
void usage()
{
	printf("Usage: %s <pid>\n", program_invocation_name);
	exit(EXIT_SUCCESS);
}

void process_args(int argc, char *argv[], pid_t *pid)
{
	if (argc != 2) usage();
	char *endptr;
	errno = 0;
	*pid = strtol(argv[1], &endptr, 10);
	//trace("%p", argv[1]);
	//trace("%p", endptr);
	if (errno || endptr == argv[1]) {
		warn(errno, "strtol");
		usage();
	}
	trace("%d", *pid);
}

/// checks input parameters and requests mem maps
int main(int argc, char *argv[])
{
	pid_t pid;
	process_args(argc, argv, &pid);
	procmap_t *maps;
	int mapcount;
	verify(get_proc_maps(pid, &maps, &mapcount));
	trace("%d", mapcount);
	print_proc_maps(stdout, maps, mapcount); 
	/*
	int nummaps;
	struct memmap_t *maps = getmaps(pid, &nummaps);
	trace("%p", maps);
	psize(maps);
	trace("%d", nummaps);
	lspotmaps(maps, nummaps);
	ptrace(PTRACE_ATTACH, pid, NULL, NULL);
	mappotmaps(maps, nummaps, argv[1], pid);
	waitpid(pid, NULL, 0);
	ptrace(PTRACE_DETACH, pid, NULL, NULL);
	*/
	free(maps);
	return EXIT_SUCCESS;
}
