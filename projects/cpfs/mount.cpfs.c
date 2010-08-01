#include "cpfs.h"
#include <fuse.h>
#include <fuse_opt.h>
#include <stdio.h>
#include <string.h>

static int fuse_statfs(char const *path, struct statvfs *stfs)
{
    return 0;
}

static struct fuse_operations cpfs_oper = {
    .statfs = NULL,
};

void print_usage(char const *argv0)
{
    fprintf(stderr,
"Usage %s <device|image_file> <mountpoint>\n"
            , argv0);
}

struct cpfs_fuse_conf {
    char *devpath;
};

static int opt_proc(
        void *data,
        char const *arg,
        int key,
        struct fuse_args *fargs)
{
#if 0
    switch (key)
    {
        case FUSE_OPT_KEY_NONOPT:
    }
#endif
    return 1;
}

int main(int argc, char *argv[])
{
    struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
    struct cpfs_fuse_conf conf;
    memset(&conf, 0, sizeof(conf));
    fuse_opt_parse(&args, &conf, NULL, opt_proc);
    return fuse_main(args.argc, args.argv, &cpfs_oper);
}
