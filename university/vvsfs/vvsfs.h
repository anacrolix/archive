#define BLOCKSIZE 512
#define BLOCKSIZE_BITS 8
#define NUMBLOCKS 100
#define MAXNAME 15

#define static_assert(cond) \
	__attribute__((unused)) extern char \
	dummy_assert_array[(cond) ? 1 : -1]

#define MAXFILESIZE 484

#define MIN(a,b) (((a) < (b)) ? (a) : (b))

#define true 1
#define false 0

/* vvsfs inode flags */
#define VVSFS_IF_DIR 1
#define VVSFS_IF_EMPTY 2

//#define VVSFS_IF_

struct vvsfs_inode {
	int32_t atime, mtime, ctime;
	uint32_t flags, uid, gid;
	uint16_t mode, size;
	char data[MAXFILESIZE];
};

static_assert(sizeof(struct vvsfs_inode) == 512);

struct vvsfs_dir_entry {
	char name[MAXNAME+1];
	int inode_number;
};
