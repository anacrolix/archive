#include "cpfs.h"
#include <stdio.h>

void print_usage(char const *argv0)
{
    fprintf(stderr,
"Usage: %s <device|image_file>\n",
            argv0);
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        print_usage(argv[0]);
        return 2;
    }
    if (!cpfs_mkfs(argv[1])) {
        fprintf(stderr, "mkfs.cpfs: Error making filesystem\n");
    }
}
