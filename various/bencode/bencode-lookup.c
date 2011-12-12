#define _POSIX_SOURCE
#include "bencode.c"
#include <stdio.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    int fd = open(argv[1], O_RDONLY);
    struct stat st[1];
    fstat(fd, st);
    char *buf = mmap(NULL, st->st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    char *p = buf;
    for (int i = 2; i < argc; ++i) {
        switch (get_type(p)) {
            case DICT:
            p = dict_get(p, argv[i]);
            break;
            case LIST:
            p = list_get(p, atoi(argv[i]));
            break;
            default:
            fprintf(stderr, "Tried to index a non-container type\n");
            return 1;
        }
    }
    printf("%.*s\n", (int)(skip_token(p) - p), p);
    return 0;
}
