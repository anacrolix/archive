AM_CFLAGS = -std=gnu99 -Wall -D_GNU_SOURCE
bin_PROGRAMS = mount.cpfs mkfs.cpfs
mount_cpfs_SOURCES = mount.cpfs.c cpfs.c
mount_cpfs_CPPFLAGS = $(FUSE_CFLAGS) -DFUSE_USE_VERSION=28
mount_cpfs_LDFLAGS = $(FUSE_LIBS)
mkfs_cpfs_SOURCES = mkfs.cpfs.c cpfs.c
mkfs_cpfs_LDADD = -lrt
