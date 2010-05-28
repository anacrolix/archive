#include "botutil.h"

int main(int argc, char **argv)
{
	pid_t pid = atoi(argv[1]);
	verify(0 == ptrace(PTRACE_ATTACH, pid, NULL, NULL));
	wait_until_tracee_stops(pid);
	verify(0 == ptrace(PTRACE_CONT, pid, NULL, 0));
	while (true)
	{
		int status;
		verify(pid == waitpid(pid, &status, 0));
		verify(WIFSTOPPED(status));
		int signal = WSTOPSIG(status);
		fprintf(stderr, "Delivering signal %d to tracee\n", signal);
		verify(0 == ptrace(PTRACE_CONT, pid, NULL, WSTOPSIG(status)));
	}
	verify(0 == ptrace(PTRACE_DETACH, pid, NULL, NULL));
	return 0;
}
