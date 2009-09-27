#include <stdlib.h>

char *hello(char *what)
{
    static char const hello[] = "hello ";
    char *p = malloc(strlen(hello) + strlen(what) + 1);
    strcpy(p, hello);
    strcat(p, what);
    return p;
}
