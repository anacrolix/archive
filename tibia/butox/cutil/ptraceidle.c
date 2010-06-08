#include "botutil.h"

int main(int argc, char **argv)
{
	pid_t pid = atoi(argv[1]);
	require(0 == ptrace(PTRACE_ATTACH, pid, NULL, NULL));
	wait_until_tracee_stops(pid);
	require(0 == ptrace(PTRACE_CONT, pid, NULL, 0));
	while (true)
	{
		int status;
		require(pid == waitpid(pid, &status, 0));
		require(WIFSTOPPED(status));
		int signal = WSTOPSIG(status);
		fprintf(stderr, "Delivering signal %d to tracee\n", signal);
		require(0 == ptrace(PTRACE_CONT, pid, NULL, WSTOPSIG(status)));
	}
	require(0 == ptrace(PTRACE_DETACH, pid, NULL, NULL));
	return 0;
}
