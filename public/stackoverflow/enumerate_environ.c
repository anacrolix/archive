#include <stdio.h>
extern char **environ;

void main()
{
    for (char **env = environ; *env; ++env)
        printf("%s\n", *env);
}
