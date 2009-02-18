#define _BSD_SOURCE
#include <sys/types.h>
#include <unistd.h>
#include "eruutil/erudebug.h"

int main()
{
	uid_t uid = getuid();
	dump(getuid(), "%d");
	if (seteuid(1000)) fatal(errno, "setuid()");
	dump(geteuid(), "%d");
	if (setuid(0)) warn(errno, "setuid()");
	pid_t pid = fork();
	if (-1 == pid) warn(errno, "fork()");
	if (!pid) {
		dump(getsid(0), "%d");
		dump(getpid(), "%d");
		dump(getppid(), "%d");
	} else {
		_exit(0);
	}
	if (fcloseall()) warn(errno, "fcloseall()");
	close(0); close(1); close(2);
	printf("hi;D\n");
	if (daemon(0, 0)) fatal(errno, "daemon()");
	while (1) {sleep(0);}
	return 0;
}
