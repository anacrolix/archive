#include <linux/module.h>
#include <linux/fs.h>
#include <linux/proc_fs.h>
#include <linux/mm.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/init.h>
#include <linux/smp_lock.h>
#include <linux/statfs.h>
#include <linux/blkdev.h>
#include <linux/buffer_head.h>
#include <linux/kernel.h>

#include <asm/uaccess.h>

#include "vvsfs.h"

/* A Very Very Simple Filesystem
   Eric McCreath 2006, 2008 - GPL

   (based on the simplistic RAM filesystem McCreath 2001)   */

/* to make use:
      make -C /usr/src/linux-source-2.6.12  SUBDIRS=$PWD modules
   to load use:
      insmod vvsfs.ko
   to mount use:
      mount -t vvsfs /dev/sda1 testdir
       (/dev/sda1 is the location of my usb drive that
         has been formated using mkfs.vvsfs)
*/

/* remove the 1 when this is no longer used in if() statements */
/* this should be passed in from the Makefile, but how? */
#define DEBUG 1
#ifdef DEBUG
#define debug(fmt, ...)	(printk(fmt, ##__VA_ARGS__))
#else
#define debug(fmt, ...) ((void)0)
#endif

#define check(x) if (!(x)) { printk("VVSFS CHECK FAILED: %s\n", #x); }

static struct inode_operations vvsfs_file_inode_operations;
static struct file_operations vvsfs_file_operations;
static struct inode_operations vvsfs_dir_inode_operations;
static struct file_operations vvsfs_dir_operations;
static struct super_operations vvsfs_ops;

static void vvsfs_put_super(struct super_block *sb)
{
	debug("vvsfs_put_super()\n");
	return;
}

static int
vvsfs_statfs(struct dentry * sb, struct kstatfs * buf)
{
	buf->f_namelen = MAXNAME;
	return 0;
}

/**
Reads a block from the block device(this will copy over the top of inode)
*/
static int vvsfs_readblock(
	struct super_block *sb, int inum, struct vvsfs_inode *inode)
{
	struct buffer_head *bh;

	debug("vvsfs_readblock(sb root: %s, inum: %d)\n",
		(sb->s_root?sb->s_root->d_name.name:0), inum);

	bh = sb_bread(sb, inum);
	check(sb->s_blocksize == BLOCKSIZE);
	memcpy(inode, bh->b_data, sb->s_blocksize);
	brelse(bh);
	return sb->s_blocksize;
}

// vvsfs_writeblock - write a block from the block device(this will just mark the block
//                      as dirtycopy)
static int vvsfs_writeblock(
	struct super_block *sb, int inum, struct vvsfs_inode *inode)
{
	struct buffer_head *bh;

	debug("vvsfs_writeblock(sb root: %s, inum: %d)\n",
		(sb->s_root?sb->s_root->d_name.name:0), inum);

	bh = sb_bread(sb, inum); // inum used as sector
	check(BLOCKSIZE == sb->s_blocksize);
	memcpy(bh->b_data, inode, BLOCKSIZE);
	mark_buffer_dirty(bh);
	sync_dirty_buffer(bh);
	brelse(bh);

	return BLOCKSIZE;
}

/**
@param filp: the directory being read
@param dirent:
@param filldir: a function pointer taking directory contents
*/
static int vvsfs_readdir(
	struct file *filp, void *dirent, filldir_t filldir)
{
	struct vvsfs_inode dirdata;
	struct inode *i;
	int nodirs;
	struct vvsfs_dir_entry *dent;
	int error, k;

	i = filp->f_dentry->d_inode;

	vvsfs_readblock(i->i_sb, i->i_ino, &dirdata);
	nodirs = dirdata.size / sizeof(struct vvsfs_dir_entry);

	debug("vvsfs_readdir(pos: %lld): entries: %d\n",
		filp->f_pos, nodirs);

	error = 0;
	k=0;
	while (!error && filp->f_pos < dirdata.size && k<nodirs) {
		dent = (struct vvsfs_dir_entry *)
			((dirdata.data) + k * sizeof(struct vvsfs_dir_entry));

		printk("adding name : %s ino : %d\n",dent->name, dent->inode_number);
		error = filldir(
			dirent, dent->name, strlen(dent->name), filp->f_pos,
			dent->inode_number, DT_REG);
		if (error)
			break;

		filp->f_pos += sizeof(struct vvsfs_dir_entry);
		k++;
	}
	// update_atime(i);

	return 0;
}

static struct inode *vvsfs_iget(
	struct super_block *sb, long unsigned ino)
{
	struct vvsfs_inode raw;
	struct inode *inode;

	debug("vvsfs_iget(ino: %lu)\n", ino);

	inode = iget_locked(sb, ino);
	if (!inode) return ERR_PTR(-ENOMEM);

	/* the following are set during iget_locked() */
	/* defaulted by alloc_inode(): nlink, blocks, sb, flags, ... */
	/* and by get_new_inode_fast(): ino */

	vvsfs_readblock(sb, ino, &raw);

	inode->i_atime.tv_sec = raw.atime;
	inode->i_mtime.tv_sec = raw.mtime;
	inode->i_ctime.tv_sec = raw.ctime;
	inode->i_atime.tv_nsec = inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec = 0;
	inode->i_uid = raw.uid;
	inode->i_gid = raw.gid;
	inode->i_mode = raw.mode;
	inode->i_size = raw.size;

	if (S_ISREG(inode->i_mode)) {
		inode->i_op = &vvsfs_file_inode_operations;
		inode->i_fop = &vvsfs_file_operations;
	} else if (S_ISDIR(inode->i_mode)) {
		inode->i_op = &vvsfs_dir_inode_operations;
		inode->i_fop = &vvsfs_dir_operations;
	} else {
		debug("VVSFS_IGET(): UNSUPPORTED MODE\n");
	}

	return inode;
// iget_failed ?
}

// vvsfs_lookup - A directory name in a directory. It basically attaches the inode
//                of the file to the directory entry.
/**

*/
static struct dentry * vvsfs_lookup(
	struct inode *dir, struct dentry *dentry, struct nameidata *nd)
{
	int nodirs;
	int k;
	struct vvsfs_inode dirdata;
	struct vvsfs_dir_entry *dent;

	debug("vvsfs_lookup(dir ino: %lu, dentry name: %s)\n",
		dir->i_ino, dentry->d_name.name);

	vvsfs_readblock(dir->i_sb, dir->i_ino, &dirdata);
	nodirs = dirdata.size / sizeof(struct vvsfs_dir_entry);

	for (k = 0; k < nodirs; k++)
	{
		dent = (struct vvsfs_dir_entry *)
			(dirdata.data + k * sizeof(struct vvsfs_dir_entry));

		if ((strlen(dent->name) == dentry->d_name.len) &&
			strncmp(dent->name, dentry->d_name.name, dentry->d_name.len) == 0)
		{
			struct inode *inode;

			inode = vvsfs_iget(dir->i_sb, dent->inode_number);
			if (IS_ERR(inode))
				return ERR_CAST(inode);
#if 0
			d_add(dentry, inode);
			return NULL;
#else
			return d_splice_alias(inode, dentry);
#endif
		}
	}
	/* found nothing */
	d_add(dentry, NULL);
	return NULL;
}

// vvsfs_empty_inode - finds the first free inode (returns -1 is unable to find one)
static int vvsfs_empty_inode(struct super_block *sb)
{
	struct vvsfs_inode block;
	int k;
	debug("vvsfs_empty_inode()\n");
	for (k = 0; k < NUMBLOCKS; k++) {
		vvsfs_readblock(sb, k, &block);
		if (block.flags & VVSFS_IF_EMPTY) {
			debug("vvsfs_empty_inode(): %d\n", k);
			return k;
		}
	}
	return -1;
}

/**
Find a spare sector and construct a new inode.
*/
struct inode *vvsfs_new_inode(
	const struct inode *dir, int mode)
{
	struct vvsfs_inode block;
	struct super_block *sb = dir->i_sb;
	struct inode *inode;
	int inum;

	debug("vvsfs_new_inode(dir ino: %lu, mode: %o)\n",
		dir->i_ino, mode);

	/* create a new inode in this super block */
	if (!(inode = new_inode(sb)))
		return ERR_PTR(-ENOMEM);

	/* find a spare inode in the vvsfs */
	inum = vvsfs_empty_inode(sb);
	if (inum == -1) {
		printk("vvsfs_new_inode(): all inodes taken\n");
		return ERR_PTR(-ENOSPC);
	}

	/* write out the inode */
	block.flags = 0;
	block.flags |= S_ISDIR(mode) ? VVSFS_IF_DIR : 0;
	block.size = 0;
	vvsfs_writeblock(sb, inum, &block);

	inode->i_sb = sb;
	inode->i_flags = 0;
	inode->i_ino = inum;
	//inode->i_blocks = 0;
	inode->i_nlink = 1;
	inode->i_size = 0;
	inode->i_uid = current->fsuid;
	inode->i_gid = current->fsgid;
	inode->i_ctime = inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
	inode->i_mode = mode; // 644 f
	//inode->i_op = NULL;

	insert_inode_hash(inode);

	return inode;
}

/**
Creates a new file in a directory.
called from namei.c:vfs_create()
*/
static int vvsfs_create(
	struct inode *dir, struct dentry *dentry, int mode,
	struct nameidata *nd)
{
	struct vvsfs_inode dir_block;
	int nr_dentry; // entry count in this dir
	struct vvsfs_dir_entry *dent; // new entry location
	struct inode *inode;

	debug("vvsfs_create(dentry name: %s, mode: %o)\n",
		dentry->d_name.name, mode);

	/* read the dir block this file is going in */
	vvsfs_readblock(dir->i_sb, dir->i_ino, &dir_block);
	nr_dentry = dir_block.size / sizeof(struct vvsfs_dir_entry);
	check(dir_block.size % sizeof(struct vvsfs_dir_entry) == 0);

	/* ensure there is enough space available for another entry */
	check(sizeof(dir_block.data) == MAXFILESIZE);
	if (dir_block.size + sizeof(*dent) > sizeof(dir_block.data)) {
		debug("vvsfs_create(): can't fit more dentries on this inode\n");
		return -ENOSPC; // correct error?
	}

	inode = vvsfs_new_inode(dir, mode);
	if (IS_ERR(inode))
		return PTR_ERR(inode);

	/* vvsfs'ify it */
	inode->i_op = &vvsfs_file_inode_operations;
	inode->i_fop = &vvsfs_file_operations;
	//inode->i_mode = mode;

	/* copy the dentry into the dir inode */
	dent = (struct vvsfs_dir_entry *)
		(dir_block.data + nr_dentry * sizeof(struct vvsfs_dir_entry));
	strncpy(dent->name, dentry->d_name.name, dentry->d_name.len);
	dent->name[dentry->d_name.len] = '\0';
	dent->inode_number = inode->i_ino;

	dir_block.size += sizeof(*dent);
	check(sizeof(*dent) == sizeof(struct vvsfs_dir_entry));

	vvsfs_writeblock(dir->i_sb, dir->i_ino, &dir_block);

	d_instantiate(dentry, inode);

	return 0;
}

/**
Called from vfs_unlink().
@param dir: the owning directory
@param dentry: the entry to be removed
@return 0 on success
*/
static int vvsfs_unlink(
	struct inode *dir, struct dentry *entry)
{
	struct vvsfs_inode block;
	unsigned long ino = entry->d_inode->i_ino;
	int index, nr_entries;
	struct vvsfs_dir_entry *e;

	debug("vvsfs_unlink(dir ino: %lu, dentry name: %s, dentry ino: %lu)\n",
		dir->i_ino, entry->d_name.name, ino);

	/* read the directory block */
	vvsfs_readblock(dir->i_sb, dir->i_ino, &block);

	nr_entries = block.size / sizeof(struct vvsfs_dir_entry);
	check(!(block.size % sizeof(struct vvsfs_dir_entry)));
	/* find the given entry in the directory */
	for (index = 0; index < nr_entries; index++) {
		e = (struct vvsfs_dir_entry *)
			(block.data + index * sizeof(struct vvsfs_dir_entry));
		if (e->inode_number == ino) {
			check(!strncmp(e->name, entry->d_name.name, entry->d_name.len));
			break;
		}
	}
	if (index >= nr_entries) {
		/* couldn't find the entry */
		return -ENOENT;
	}

	/* shift the rest of the directory over this entry */
	for (; index < nr_entries - 1; index++) {
		e = (struct vvsfs_dir_entry *)
			(block.data + index * sizeof(struct vvsfs_dir_entry));
		*e = *(e + 1);
	}
	block.size -= sizeof(*e);
	vvsfs_writeblock(dir->i_sb, dir->i_ino, &block);

	/* mark the deleted inode as empty */
	vvsfs_readblock(dir->i_sb, ino, &block);
	block.flags |= VVSFS_IF_EMPTY;
	vvsfs_writeblock(dir->i_sb, ino, &block);

	return 0;
}

// vvsfs_file_write - write to a file
static ssize_t vvsfs_file_write(
	struct file * filp, const char * buf, size_t count,
	loff_t *ppos)
{
	struct vvsfs_inode filedata;
	struct inode *inode = filp->f_dentry->d_inode;
	ssize_t pos;
	struct super_block * sb;
	char * p;

	if (DEBUG) printk("vvsfs - file write - count : %lu ppos %Ld\n",count,*ppos);

	if (!inode) {
		printk("vvsfs - Problem with file inode\n");
		return -EINVAL;
	}

	if (!(S_ISREG(inode->i_mode))) {
		printk("vvsfs - not regular file\n");
		return -EINVAL;
	}
	if (*ppos > inode->i_size || count <= 0) {
		printk("vvsfs - attempting to write over the end of a file.\n");
		return 0;
	}
	sb = inode->i_sb;


	vvsfs_readblock(sb,inode->i_ino,&filedata);

	if (filp->f_flags & O_APPEND)
		pos = inode->i_size;
	else
		pos = *ppos;

	if (pos + count > MAXFILESIZE) return -ENOSPC;

	filedata.size = pos+count;
	p = filedata.data + pos;
	if (copy_from_user(p,buf,count))
		return -ENOSPC;
	*ppos = pos;
	buf += count;

	inode->i_size = filedata.size;

	vvsfs_writeblock(sb,inode->i_ino,&filedata);

	if (DEBUG)
		printk("vvsfs - file write done : %lu ppos %Ld\n",
			count, *ppos);

	return count;
}

// vvsfs_file_read - read data from a file
static ssize_t vvsfs_file_read(
	struct file *filp, char *buf, size_t count, loff_t *ppos)
{
	struct vvsfs_inode filedata;
	struct inode *inode = filp->f_dentry->d_inode;
	struct super_block *sb = inode->i_sb;
	loff_t offset = *ppos;

	debug("vvsfs_file_read(count: %lu, offset: %lld)\n",
		count, *ppos);

	if (!inode) {
		printk("vvsfs: problem with file inode\n");
		return -EINVAL;
	}
	if (!(S_ISREG(inode->i_mode))) {
		printk("vvsfs: not regular file\n");
		return -EINVAL;
	}
	if (*ppos > inode->i_size || count <= 0) {
		printk("vvsfs: attempting to write over the end of a file\n");
		return 0;
	}

	vvsfs_readblock(sb, inode->i_ino, &filedata);

	count = (count <= inode->i_size - *ppos) ?:
		inode->i_size - *ppos;
	*ppos += count;
	if (copy_to_user(buf, filedata.data + offset, count))
		return -EIO;

	return count;
}

/**
Returns non-zero if the requested permission bits are present
*/
static inline int has_perm(
	int mask, short unsigned mode)
{
	debug("vvsfs: has_perm(mask: %o, mode: %o)\n",
		mask, mode);
	check(!(mask & ~07));
	mask &= 07;
	if ((mode & mask) == mask)
		return 1;
	else
		return 0;
}

static int vvsfs_permission(
	struct inode *inode, int mask, struct nameidata *nd)
{
	debug("vvsfs_permission(ino: %lu, mask: %x, name: %s, mode: %o)\n",
		inode->i_ino, mask, (nd?nd->last.name:0), inode->i_mode);
	check(nd);
	check(!(mask & ~07));
	check(S_ISREG(inode->i_mode));
	if (inode->i_uid == current->fsuid) {
		if (has_perm(mask, inode->i_mode >> 6))
			goto allow;
	}
	if (in_group_p(inode->i_gid)) {
		if (has_perm(mask, inode->i_mode >> 3))
			goto allow;
	}
	if (has_perm(mask, inode->i_mode))
		goto allow;
	return -EACCES;
allow:
	return 0;
}

static struct file_operations vvsfs_file_operations = {
	read:	vvsfs_file_read,        /* read */
	write:	vvsfs_file_write,       /* write */
};

static struct inode_operations vvsfs_file_inode_operations = {
	permission: vvsfs_permission,
};

static struct file_operations vvsfs_dir_operations = {
	readdir:        vvsfs_readdir,          /* readdir */
};

static struct inode_operations vvsfs_dir_inode_operations = {
	create:     vvsfs_create,                   /* create */
	lookup:     vvsfs_lookup,           /* lookup */
	unlink:		vvsfs_unlink,
};

// vvsfs_read_inode - read an inode from the block device
static void vvsfs_read_inode(struct inode *i)
{
#if 0
	struct vvsfs_inode filedata;

	if (DEBUG) {
		printk("vvsfs - read inode - ino : %d", (unsigned int) i->i_ino);
		printk(" inode %p", i);
		printk(" super %p\n", i->i_sb);
	}

	vvsfs_readblock(i->i_sb,i->i_ino,&filedata);

	/* get vvs inode info */
	printk("Read Inode 1\n");

	i->i_nlink = 1;
	i->i_size = filedata.size;

	i->i_uid = 0;
	i->i_gid = 0;

	i->i_ctime = i->i_mtime = i->i_atime = CURRENT_TIME;


	if (filedata.is_directory) {
		i->i_mode = S_IRUGO|S_IWUSR|S_IFDIR;
		i->i_op = &vvsfs_dir_inode_operations;
		i->i_fop = &vvsfs_dir_operations;
	} else {
		i->i_mode = S_IRUGO|S_IWUSR|S_IFREG;
		i->i_op = &vvsfs_file_inode_operations;
		i->i_fop = &vvsfs_file_operations;
	}
#endif
}

/**
Initializes a newly mounting vvsfs device.
Super block attributes are not stored on disk, so they're generated here.
@param s: the super block attributes to fill
*/
static int vvsfs_fill_super(
	struct super_block *s, void *data, int silent)
{
	struct inode *i;
	int hblock;

	debug("vvsfs_fill_super()\n");

	s->s_flags = MS_NOSUID | MS_NOEXEC;
	s->s_op = &vvsfs_ops; // superblock operations

	i = new_inode(s);

	i->i_sb = s;
	i->i_ino = 0;
	i->i_flags = 0;
	i->i_mode = S_IRUGO|S_IWUSR|S_IXUGO|S_IFDIR; // 755 d
	i->i_op = &vvsfs_dir_inode_operations;
	i->i_fop = &vvsfs_dir_operations;

	hblock = bdev_hardsect_size(s->s_bdev);
	if (hblock > BLOCKSIZE) {
		printk("device blocks are too small!!");
		return -1;
	}

	set_blocksize(s->s_bdev, BLOCKSIZE);
	s->s_blocksize = BLOCKSIZE;
	s->s_blocksize_bits = BLOCKSIZE_BITS;

	s->s_root = d_alloc_root(i); /*2.4*/

	return 0;
}

static int vvsfs_write_inode(
	struct inode *inode, int sync)
{
	struct vvsfs_inode vi;

	debug("vvsfs_write_inode(ino: %lu, sync: %d)\n",
		inode->i_ino, sync);
	check(!sync);
	check(inode->i_sb);

	/* write inode to device */
	vvsfs_readblock(inode->i_sb, inode->i_ino, &vi);
#if 0
struct vvsfs_inode {
	int32_t atime, mtime, ctime;
	uint32_t flags, uid, gid;
	uint16_t mode, size;
	char data[MAXFILESIZE];
};
#endif
	vi.atime = inode->i_atime.tv_sec;
	vi.mtime = inode->i_mtime.tv_sec;
	vi.ctime = inode->i_ctime.tv_sec;
	//check((vi.flags & VVSFS_IF_DIR) == S_ISDIR(inode->i_mode));
	vi.uid = inode->i_uid;
	vi.gid = inode->i_gid;
	vi.mode = inode->i_mode;
	//check(vi.size == inode->i_size);
	vi.size = inode->i_size;

	vvsfs_writeblock(inode->i_sb, inode->i_ino, &vi);

	return 0;
}

static struct super_operations vvsfs_ops = {
	//put_inode: vvsfs_read_inode,
	.statfs = vvsfs_statfs,
	.put_super = vvsfs_put_super,
	.write_inode = vvsfs_write_inode,
};

int vvsfs_get_sb(
	struct file_system_type * fs_type, int flags,
	const char * dev_name, void * data, struct vfsmount * mnt)
{
	return get_sb_bdev(
		fs_type, flags, dev_name, data, vvsfs_fill_super, mnt);
}

static struct file_system_type vvsfs_type = {
	.owner		= THIS_MODULE,
	.name           = "vvsfs",
	.get_sb         = vvsfs_get_sb,
	.kill_sb        = kill_block_super,
	.fs_flags       = FS_REQUIRES_DEV,
};

int init_vvsfs_module(void)
{
	printk("Registering the vvsfs.\n");
	return register_filesystem(&vvsfs_type);
}

void cleanup_vvsfs_module(void)
{
	printk("Unregistering the vvsfs.\n");
	unregister_filesystem(&vvsfs_type);
}

module_init(init_vvsfs_module);
module_exit(cleanup_vvsfs_module);
