#include <sys/stat.h>
#include <sys/types.h>
#include <assert.h>
#include <limits.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

typedef int32_t blkno_t;
typedef uint32_t cpfs_blksize_t;
typedef blkno_t cpfs_ino_t;

typedef struct {
    char fsident[32];
    blkno_t blkcount;
    uint32_t blksize;
} br_t;

typedef struct {
    uint64_t sec;
    uint32_t ns;
    uint32_t _pad0;
} cpfs_time_t;

typedef struct {
    cpfs_ino_t ino;
    uint32_t mode;
    int32_t nlink;
    uint32_t uid;
    uint32_t gid;
    uint64_t rdev;
    uint64_t size;
    cpfs_time_t atime;
    cpfs_time_t mtime;
    cpfs_time_t ctime;

} inode_t;

typedef struct {
    cpfs_blksize_t block_size;
    blkno_t total_length;
    blkno_t bitmap_density;
    blkno_t master_start;
    blkno_t master_length;
    blkno_t master_end;
    blkno_t bitmap_start;
    blkno_t bitmap_length;
    blkno_t bitmap_end;
    blkno_t data_start;
    blkno_t data_length;
    blkno_t data_end;
} geo_t;

typedef struct {
    geo_t geo;
    FILE *dev;
} cpfs_live_t;

typedef enum {
    NONE,
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    CRITICAL,
} log_t;

static const char *logstrs[] = {
    NULL, "debug", "info", "warning", "error", "critical",
};

__attribute__((format(printf, 2, 3)))
static void cpfs_log(log_t level, char const *fmt, ...)
{
    fprintf(stderr, "cpfs: %s: ", logstrs[level]);
    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    fputc('\n', stderr);
}

#define log_debug(fmt, ...) cpfs_log(DEBUG, fmt, ##__VA_ARGS__)

#if 0
__attribute__((format, printf, 1, 2))
static void log_syserr(fmt, ...)
{

}
#endif

cpfs_live_t *cpfs_load(char const *path)
{
    cpfs_live_t *cpfs = malloc(sizeof(*cpfs));
    memset(cpfs, 0, sizeof(*cpfs));
    cpfs->dev = fopen(path, "r+b");
    br_t br;
    fread(&br, sizeof(br), 1, cpfs->dev);
    if (0 != strncmp("cpfs1", br.fsident, sizeof(br.fsident)))
        return NULL;
    geo_t *geo = &cpfs->geo;
    geo->block_size = br.blksize;
    geo->total_length = br.blkcount;
    blkno_t blocks_left = geo->total_length;
    geo->bitmap_density = br.blksize * CHAR_BIT;
    geo->master_start = 0;
    geo->master_length = 1;
    blocks_left -= geo->master_length;
    geo->master_end = geo->master_start + geo->master_length;
    geo->bitmap_start = geo->master_end;
    geo->bitmap_length = (blocks_left + geo->bitmap_density) / (geo->bitmap_density + 1);
    blocks_left -= geo->bitmap_length;
    geo->bitmap_end = geo->bitmap_start + geo->bitmap_length;
    geo->data_start = geo->bitmap_end;
    geo->data_length = blocks_left;
    geo->data_end = geo->data_start + geo->data_length;
    return cpfs;
}

static bool br_reset(char const *path)
{
    bool ret = false;
    FILE *fp = fopen(path, "r+b");
    if (!fp)
        goto out;
    int fd = fileno(fp);
    if (fd == -1)
        goto out;
    struct stat st;
    if (0 != fstat(fd, &st))
        goto out;
    br_t br = {
        .fsident = "cpfs1",
        .blksize = 512,
    };
    // we can't use partial blocks at all, don't round up
    br.blkcount = st.st_size / br.blksize;
    if (1 != fwrite(&br, sizeof(br), 1, fp))
        goto out;
    ret = true;
out:
    if (0 != fclose(fp))
        ret = false;
    return ret;
}

#if 0
static bool bitmap_free(blkno_t blkno)
{
}
#endif

static bool block_read(
        cpfs_live_t *cpfs,
        blkno_t blkno,
        char *buf,
        size_t count,
        cpfs_blksize_t offset)
{
    assert(0 <= blkno && blkno < cpfs->geo.total_length);
    assert(0 <= count && count <= cpfs->geo.block_size);
    assert(0 <= offset && offset < cpfs->geo.block_size);
    assert(count + offset <= cpfs->geo.block_size);
    if (0 != fseek(cpfs->dev, blkno * cpfs->geo.block_size + offset, SEEK_SET))
        return false;
    if (1 != fread(buf, count, 1, cpfs->dev))
        return false;
    return true;
}

static bool block_write(
        cpfs_live_t *cpfs,
        blkno_t blkno,
        void const *buf,
        size_t count,
        size_t offset)
{
    if (blkno < 0 || blkno >= cpfs->geo.total_length)
        return false;
    if (offset + count > cpfs->geo.block_size)
        return false;
    if (0 != fseek(cpfs->dev, blkno * cpfs->geo.block_size + offset, SEEK_SET))
        return false;
    if (1 != fwrite(buf, count, 1, cpfs->dev))
        return false;
    return true;
}

static size_t first_unset_bit(char unsigned const *buf, size_t bit_count, size_t start_bit)
{
    for (; start_bit < bit_count; ++start_bit)
    {
        size_t buf_index = start_bit / CHAR_BIT;
        int bit_index = start_bit % CHAR_BIT;
        if (!((buf[buf_index] >> bit_index) & 1))
            return start_bit;
    }
    return -1;
}

static blkno_t block_alloc(
        cpfs_live_t *cpfs)
{
    //blkno_t blkno = cpfs->geo.data_start;
    for (   blkno_t bmblki = 0;
            bmblki < cpfs->geo.bitmap_length;
            ++bmblki)
    {
        char data[cpfs->geo.block_size];
        if (!block_read(cpfs, bmblki + cpfs->geo.bitmap_start, data, sizeof(data), 0))
            return false;
        size_t bit = first_unset_bit((char unsigned *)data, cpfs->geo.bitmap_density, 0);
        if (bit != -1)
        {
            data[bit / CHAR_BIT] |= 1 << (bit % CHAR_BIT);
            if (!block_write(cpfs, bmblki + cpfs->geo.bitmap_start, data, sizeof(data), 0))
                return false;
            return cpfs->geo.data_start + bmblki * cpfs->geo.bitmap_density + bit;
        }
    }
    return -1;
}

static bool bitmap_reset(cpfs_live_t *cpfs)
{
    log_debug("Resetting bitmap");
    char block_buffer[cpfs->geo.block_size];
    memset(block_buffer, 0, sizeof(block_buffer));
    for (   blkno_t bitmap_block_index = 0;
            bitmap_block_index != cpfs->geo.bitmap_length;
            ++bitmap_block_index)
    {
        blkno_t block_overhang_bit_offset =
            cpfs->geo.data_length - bitmap_block_index * cpfs->geo.bitmap_density;
        // the overhang starts in this block
        if (block_overhang_bit_offset < cpfs->geo.bitmap_density)
        {
            // the overhang can only exist in the final block
            if (bitmap_block_index != cpfs->geo.bitmap_length - 1)
                return false;
            size_t byte_index = block_overhang_bit_offset / CHAR_BIT;
            size_t bit_index = block_overhang_bit_offset % CHAR_BIT;
            block_buffer[byte_index] = ~((1 << bit_index) - 1);
            while (++byte_index < sizeof(block_buffer))
            {
                block_buffer[byte_index] = -1;
            }
        }
        if (!block_write(
                cpfs,
                bitmap_block_index + cpfs->geo.bitmap_start,
                block_buffer,
                sizeof(block_buffer),
                0))
            return false;
    }
    return true;
}

static bool inode_put(cpfs_live_t *cpfs, cpfs_ino_t ino, inode_t const *inode)
{
    return block_write(cpfs, ino, inode, sizeof(*inode), 0);
}

static cpfs_ino_t root_ino(cpfs_live_t *cpfs)
{
    return cpfs->geo.data_start;
}

static bool util_curtime(cpfs_time_t *cpfstim)
{
    struct timespec tp;
    if (0 != clock_gettime(CLOCK_REALTIME, &tp))
        return false;
    cpfstim->sec = tp.tv_sec;
    cpfstim->ns = tp.tv_nsec;
    return true;
}

bool root_reset(cpfs_live_t *cpfs)
{
    if (block_alloc(cpfs) != root_ino(cpfs))
    {
        cpfs_log(ERROR, "Root block is already allocated");
        return false;
    }
    cpfs_time_t cpfstim;
    if (!util_curtime(&cpfstim))
        return false;
    inode_t inode = {
        .ino = root_ino(cpfs),
        .mode = S_IFDIR|0755,
        .nlink = 2,
        .uid = 0,
        .gid = 0,
        .rdev = 0,
        .size = 0,
        .atime = cpfstim,
        .mtime = cpfstim,
        .ctime = cpfstim,
    };
    inode_put(cpfs, root_ino(cpfs), &inode);
    return true;
}

bool cpfs_unload(cpfs_live_t *cpfs)
{
    bool ret = true;
    if (0 != fclose(cpfs->dev))
        ret = false;
    free(cpfs);
    return ret;
}

bool cpfs_mkfs(char const *path)
{
    bool ret = false;
    if (!br_reset(path))
        goto out;
    cpfs_live_t *cpfs = cpfs_load(path);
    if (!cpfs)
        goto out;
    if (!bitmap_reset(cpfs))
        goto out_loaded;
    if (!root_reset(cpfs))
        goto out_loaded;
    ret = true;
out_loaded:
    if (!cpfs_unload(cpfs))
        ret = false;
out:
    return ret;
}
