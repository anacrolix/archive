#include <unistd.h>

//extern char **environ;

int main(/*int argc, char *argv[]*/)
{
	char **e = __environ;
	while (*e) puts(*e++);
	return 0;
}
