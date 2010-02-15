#include <assert.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/ptrace.h>

int main()
{
    pid_t pid = fork();
    assert(pid != -1);
    int status;
    long readme = 0;
    if (pid)
    {
        readme = 42;
        printf("parent: child pid is %d\n", pid);
        assert(pid == wait(&status));
        printf("parent: child terminated?\n");
        assert(0 == status);
    }
    else
    {
        pid_t tracee = getppid();
        printf("child: parent pid is %d\n", tracee);
        sleep(1); // give parent time to set readme
        assert(0 == ptrace(PTRACE_ATTACH, tracee));
        assert(tracee == waitpid(tracee, &status, 0));
        printf("child: parent should be stopped\n");
        printf("child: peeking at parent: %ld\n", ptrace(PTRACE_PEEKDATA, tracee, &readme));
    }
    return 0;
}
