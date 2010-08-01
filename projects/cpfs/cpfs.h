#include <sys/statvfs.h>
#include <stdbool.h>

typedef struct CpfsPrivate Cpfs;
bool cpfs_mkfs(char const *);
Cpfs *cpfs_load(char const *devpath);
bool cpfs_unload(Cpfs *);
int cpfs_statvfs(Cpfs *, struct statvfs *);
