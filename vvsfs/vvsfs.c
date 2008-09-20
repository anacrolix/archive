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
#define check(x) if (!(x)) { printk("VVSFS CHECK FAILED: %s", #x); }

static struct inode_operations vvsfs_file_inode_operations;
static struct file_operations vvsfs_file_operations;
static struct super_operations vvsfs_ops;

static void
vvsfs_put_super(struct super_block *sb) {
  if (DEBUG) printk("vvsfs - put_super\n");
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

	debug("vvsfs_readblock(root: %s, inode: %d)\n",
		sb->s_root->d_name.name, inum);

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

	debug("vvsfs_writeblock(super_block root: %s, inum: %d)\n",
		sb->s_root->d_name.name, inum);

	bh = sb_bread(sb, inum); // inum used as sector
	check(BLOCKSIZE == sb->s_blocksize);
	memcpy(bh->b_data, inode, BLOCKSIZE);
	mark_buffer_dirty(bh);
	sync_dirty_buffer(bh);
	brelse(bh);

	return BLOCKSIZE;
}

// vvsfs_readdir - reads a directory and places the result using filldir

static int
vvsfs_readdir(struct file *filp, void *dirent, filldir_t filldir) {

  struct vvsfs_inode dirdata;
  struct inode *i;
  int nodirs;
  struct vvsfs_dir_entry *dent;
  int error, k;

  if (DEBUG) printk("vvsfs - readdir\n");


  i = filp->f_dentry->d_inode;

  vvsfs_readblock(i->i_sb,i->i_ino,&dirdata);
  nodirs = dirdata.size/sizeof(struct vvsfs_dir_entry);

  if (DEBUG) printk("Number of entries %d fpos %Ld\n",nodirs, filp->f_pos);

  error = 0;
  k=0;
  while (!error && filp->f_pos < dirdata.size && k<nodirs) {

    dent = (struct vvsfs_dir_entry *) ((dirdata.data) + k*sizeof(struct vvsfs_dir_entry));

    printk("adding name : %s ino : %d\n",dent->name, dent->inode_number);
    error = filldir(dirent,
		    dent->name, strlen(dent->name), filp->f_pos, dent->inode_number,DT_REG);
    if (error)
      break;

    filp->f_pos += sizeof(struct vvsfs_dir_entry);
    k++;
  }
 // update_atime(i);
  printk("done readdir\n");

  return 0;
}


// vvsfs_lookup - A directory name in a directory. It basically attaches the inode
//                of the file to the directory entry.
static struct dentry * vvsfs_lookup(
	struct inode *dir, struct dentry *dentry, struct nameidata *nd)
{
	int nodirs;
	int k;
	struct vvsfs_inode dirdata;
	struct inode *inode = NULL;
	struct vvsfs_dir_entry *dent;

	//debug("vvsfs_lookup(

	if (DEBUG) printk("vvsfs - lookup\n");


	vvsfs_readblock(dir->i_sb,dir->i_ino,&dirdata);
	nodirs = dirdata.size/sizeof(struct vvsfs_dir_entry);

	for (k=0;k<nodirs;k++) {
	dent = (struct vvsfs_dir_entry *) ((dirdata.data) + k*sizeof(struct vvsfs_dir_entry));

	if ((strlen(dent->name) == dentry->d_name.len) &&
	strncmp(dent->name,dentry->d_name.name,dentry->d_name.len) == 0) {
	inode = iget_locked(dir->i_sb, dent->inode_number);

	if (!inode)
	return ERR_PTR(-EACCES);

	d_add(dentry, inode);
	return NULL;

	}
	}
	d_add(dentry, inode);
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
		if (block.is_empty) {
			debug("vvsfs_empty_inode(): %d\n", k);
			return k;
		}
	}
	return -1;
}

/** vvsfs_new_inode - find and construct a new inode. */
struct inode *vvsfs_new_inode(const struct inode *dir)
{
	struct vvsfs_inode block;
	struct super_block *sb = dir->i_sb;
	struct inode *inode;
	int inum;

	debug("vvsfs_new_inode()\n");

	/* create a new inode in this super block */
	if (!dir || !(inode = new_inode(sb)))
		return NULL;

	/* find a spare inode in the vvsfs */
	inum = vvsfs_empty_inode(sb);
	if (inum == -1) {
		printk("vvsfs: all inodes taken\n");
		return NULL;
	}

	/* write out the inode */
	block.is_empty = false;
	block.size = 0;
	block.is_directory = false;
	vvsfs_writeblock(sb, inum, &block);

	inode->i_sb = sb;
	inode->i_flags = 0;
	inode->i_ino = inum;
	inode->i_nlink = 1;
	inode->i_size = 0;
	inode->i_uid = 0;
	inode->i_gid = 0;
	inode->i_ctime = inode->i_mtime = inode->i_atime = CURRENT_TIME;
	inode->i_mode = S_IRUGO|S_IWUSR|S_IFREG; // 644 f
	inode->i_op = NULL;

	insert_inode_hash(inode);

	return inode;
}

/**
vvsfs_create - create a new file in a directory
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

	debug("vvsfs_create(dentry name: %s, mode: %d)\n",
		dentry->d_name.name, mode);

	/* get an vfs inode */
	if (!dir) return -1;

	inode = vvsfs_new_inode(dir);
	if (!inode) return -ENOSPC;

	/* vvsfs'ify it */
	inode->i_op = &vvsfs_file_inode_operations;
	inode->i_fop = &vvsfs_file_operations;
	inode->i_mode = mode;

	/* read the dir block this file is going in */
	vvsfs_readblock(dir->i_sb, dir->i_ino, &dir_block);
	nr_dentry = dir_block.size / sizeof(struct vvsfs_dir_entry);
	check(dir_block.size % sizeof(struct vvsfs_dir_entry) == 0);

	/* copy the dentry into the dir inode */
	dent = dir_block.data + nr_dentry * sizeof(struct vvsfs_dir_entry);
	strncpy(dent->name, dentry->d_name.name, dentry->d_name.len);
	dent->name[dentry->d_name.len] = '\0';
	dent->inode_number = inode->i_ino;

	dir_block.size += sizeof(*dent);
	check(sizeof(*dent) == sizeof(struct vvsfs_dir_entry));

	vvsfs_writeblock(dir->i_sb, dir->i_ino, &dir_block);

	d_instantiate(dentry, inode);

	return 0;
}

// vvsfs_file_write - write to a file
static ssize_t
vvsfs_file_write(
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

static struct file_operations vvsfs_file_operations = {
	read:	vvsfs_file_read,        /* read */
	write:	vvsfs_file_write,       /* write */
};

static struct inode_operations vvsfs_file_inode_operations = {
};

static struct file_operations vvsfs_dir_operations = {
	readdir:        vvsfs_readdir,          /* readdir */
};

static struct inode_operations vvsfs_dir_inode_operations = {
	create:     vvsfs_create,                   /* create */
	lookup:     vvsfs_lookup,           /* lookup */
//	unlink:		vvsfs_unlink,
};

// vvsfs_read_inode - read an inode from the block device
static void
vvsfs_read_inode(struct inode *i)
{

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
}

// vvsfs_fill_super - read the super block (this is simple as we do not
//                    have one in this file system)
static int vvsfs_fill_super(struct super_block *s, void *data, int silent)
{
  struct inode *i;
  int hblock;

  if (DEBUG) printk("vvsfs - fill super\n");

  s->s_flags = MS_NOSUID | MS_NOEXEC;
  s->s_op = &vvsfs_ops;

  i = new_inode(s);

  i->i_sb = s;
  i->i_ino = 0;
  i->i_flags = 0;
  i->i_mode = S_IRUGO|S_IWUSR|S_IFDIR;
  i->i_op = &vvsfs_dir_inode_operations;
  i->i_fop = &vvsfs_dir_operations;
  printk("inode %p\n", i);


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

static struct super_operations vvsfs_ops = {
	//put_inode: vvsfs_read_inode,
	statfs: vvsfs_statfs,
	put_super: vvsfs_put_super,
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

