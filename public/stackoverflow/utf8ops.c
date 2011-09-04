#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

size_t utf8len(char *s)
{
    size_t len = 0;
    for (; *s; ++s) if ((*s & 0xC0) != 0x80) ++len;
    return len;
}

char *utf8index(char *s, size_t pos)
{
    ++pos;
    for (; *s; ++s) {
        //if (!(*s & 0x80) || ((*s & 0xc0) == 0xc0)) --pos;
        if ((*s & 0xC0) != 0x80) --pos;
        if (pos == 0) return s;
    }
    return NULL;
}

void utf8slice(char *s, ssize_t *start, ssize_t *end)
{
    char *p = utf8index(s, *start);
    *start = p ? p - s : -1;
    p = utf8index(s, *end);
    *end = p ? p - s : -1;
}

char *utf8cat(char *dest, char *src)
{
    return strcat(dest, src);
}

int main(int argc, char **argv)
{
    char *p = malloc(0);
    size_t len = 0;
    while (true) {
        p = realloc(p, len + 0x10000);
        ssize_t cnt = read(STDIN_FILENO, p + len, 0x10000);
        if (cnt == -1) {
            perror("read");
            abort();
        } else if (cnt == 0) {
            break;
        } else {
            len += cnt;
        }
    }
    printf("utf8len=%zu\n", utf8len(p));
    ssize_t start = 2, end = 3;
    utf8slice(p, &start, &end);
    printf("utf8slice[2:3]=%.*s\n", end - start, p + start);
    start = 3; end = 4;
    utf8slice(p, &start, &end);
    printf("utf8slice[3:4]=%.*s\n", end - start, p + start);
    return 0;
}
