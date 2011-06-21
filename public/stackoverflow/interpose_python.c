#define _GNU_SOURCE

#include <sys/types.h>
#include <sys/stat.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdio.h>
#include <unistd.h>

typedef int (*openX_proto)(char const *, int, ...);

static openX_proto next_open = NULL;
static openX_proto next_open64 = NULL;

void __attribute__((constructor)) sandbox_init(void)
{
    fprintf(stderr, "%s", "sandbox_init()\n");
    next_open = dlsym(RTLD_NEXT, "open");
    next_open64 = dlsym(RTLD_NEXT, "open64");
}

void __attribute__((destructor)) sandbox_fini(void)
{
    fprintf(stderr, "%s", "sandbox_fini()\n");
}

static int openX(openX_proto func, char const *pathname, int flags, va_list ap)
{
    if (flags & O_RDWR) {
        flags &= ~O_RDWR;
        flags |= O_RDONLY;
    } else if (flags & O_WRONLY) {
        flags &= ~O_WRONLY;
    }
    return func(pathname, flags, va_arg(ap, mode_t));
}

int open(char const *pathname, int flags, ...)
{
    fprintf(stderr, "open()\n");
    va_list ap;
    va_start(ap, flags);
    int ret = openX(next_open, pathname, flags, ap);
    va_end(ap);
    return ret;
}

int open64(char const *pathname, int flags, ...)
{
    fprintf(stderr, "open64()\n");
    va_list ap;
    va_start(ap, flags);
    int ret = openX(next_open64, pathname, flags, ap);
    va_end(ap);
    return ret;
}
