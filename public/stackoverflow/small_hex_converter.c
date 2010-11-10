#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    int offset = atoi(argv[2]);
    argv[1][offset + 4] = '\0';
    printf("%lu\n", strtol(argv[1] + offset, NULL, 0x10));
}
