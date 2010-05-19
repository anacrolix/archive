#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/ptrace.h>

int main(int argc, char **argv)
{
	pid_t pid = atoi(argv[1]);
	if (-1 == ptrace(PTRACE_ATTACH, pid, NULL, NULL))
	{
		perror("ptrace");
	}
	else
	{
		while (true)
		{
			char buf[1];
			ssize_t readret = read(STDIN_FILENO, buf, 1);
		}
		assert(-1 != ptrace(PTRACE_DETACH, pid, NULL, 0));
	}
	return 0;
}
