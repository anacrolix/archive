#include "config.h"
#include "cpfs.h"
#include <fuse.h>
#include <fuse_opt.h>
#include <assert.h>
#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int fuse_statfs(char const *path, struct statvfs *stfs)
{
    struct fuse_context *fusectx = fuse_get_context();
    return -cpfs_statvfs(fusectx->private_data, stfs);
}

static struct fuse_operations cpfs_oper = {
    .statfs = fuse_statfs,
};

static void print_usage()
{
    fprintf(stderr,
"\n"
PACKAGE_STRING " Cross Platform Filesystem\n"
"\n"
"Copyright (C) 2010 Matthew Joiner <anacrolix@gmail.com>\n"
"Usage: %s <device|image_file> <mountpoint>\n"
"\n"
            , program_invocation_short_name);
    char *argv[] = {program_invocation_name, "-ho", NULL};
    fuse_main(2, argv, NULL, NULL);
}

struct cpfs_fuse_conf {
    char const *devpath;
    char const *fsname;
};

enum {
    KEY_HELP,
};

static struct fuse_opt cpfs_fuse_opts[] = {
    FUSE_OPT_KEY("-h", KEY_HELP),
    FUSE_OPT_KEY("--help", KEY_HELP),
    {"fsname=%s", offsetof(struct cpfs_fuse_conf, fsname), -1},
    FUSE_OPT_END,
};

static int opt_proc(
        void *data,
        char const *arg,
        int key,
        struct fuse_args *fargs)
{
    struct cpfs_fuse_conf *conf = data;
    switch (key)
    {
    case FUSE_OPT_KEY_NONOPT:
        // take the first nonopt
        if (!conf->devpath) {
            conf->devpath = arg;
            return 0;
        } // pass other opts into fuse
        else {
            return 1;
        }
        return -1;
    case KEY_HELP:
        print_usage();
        exit(0);
        return -1;
    default:
        // just pass them on to fuse
        return 1;
    }
}

int main(int argc, char *argv[])
{
    struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
    struct cpfs_fuse_conf conf;
    memset(&conf, 0, sizeof(conf));
    conf.fsname = "cpfs";
    if (0 != fuse_opt_parse(&args, &conf, cpfs_fuse_opts, opt_proc)) {
        fprintf(stderr, "%s", "Error parsing options\n");
        return 1;
    }
    if (!conf.devpath) {
        fprintf(stderr, "Missing device path parameter\n");
        return 2;
    }
    char *arg = strdup("-ofsname=");
    arg = realloc(arg, strlen(arg) + strlen(conf.fsname) + 1);
    strcat(arg, conf.fsname);
    if (fuse_opt_add_arg(&args, arg)) {
        fprintf(stderr, "Error setting default filesystem name\n");
        return 2;
    }
    free(arg);
    Cpfs *cpfs = cpfs_load(conf.devpath);
    if (!cpfs) {
        fprintf(stderr, "%s", "Error loading filesystem\n");
        return 1;
    }
    int fuse_ret = fuse_main(args.argc, args.argv, &cpfs_oper, cpfs);
    if (fuse_ret) {
        fprintf(stderr, "Error: fuse_main returned %d\n", fuse_ret);
    }
    if (!cpfs_unload(cpfs)) {
        fprintf(stderr, "%s\n", "Error unloading filesystem");
        if (fuse_ret == 0) {
            return 1;
        }
    }
    return fuse_ret;
}
