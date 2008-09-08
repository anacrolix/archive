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

#define DEBUG 1

static struct inode_operations vvsfs_file_inode_operations;
static struct file_operations vvsfs_file_operations;
static struct super_operations vvsfs_ops;



static void
vvsfs_put_super(struct super_block *sb) {
  if (DEBUG) printk("vvsfs - put_super\n");
  return;
}

static int 
vvsfs_statfs(struct super_block *sb, struct kstatfs *buf) {
  //  if (DEBUG) printk("vvsfs - statfs\n");

  buf->f_namelen = MAXNAME;
  return 0;
}



// vvsfs_readblock - reads a block from the block device(this will copy over
//                      the top of inode)
static int
vvsfs_readblock(struct super_block *sb, int inum, struct vvsfs_inode *inode) {
  struct buffer_head *bh;

  if (DEBUG) printk("vvsfs - readblock : %d\n", inum);
  
  bh = sb_bread(sb,inum);
  memcpy((void *) inode, (void *) bh->b_data, BLOCKSIZE);
  brelse(bh);
  if (DEBUG) printk("vvsfs - readblock done : %d\n", inum);
  return BLOCKSIZE;
}

// vvsfs_writeblock - write a block from the block device(this will just mark the block
//                      as dirtycopy)
static int
vvsfs_writeblock(struct super_block *sb, int inum, struct vvsfs_inode *inode) {
  struct buffer_head *bh;

  if (DEBUG) printk("vvsfs - writeblock : %d\n", inum);

  bh = sb_bread(sb,inum);
  memcpy(bh->b_data, inode, BLOCKSIZE);
  mark_buffer_dirty(bh);
  sync_dirty_buffer(bh);
  brelse(bh);
  if (DEBUG) printk("vvsfs - writeblock done: %d\n", inum);
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
static struct dentry *
vvsfs_lookup(struct inode *dir, struct dentry *dentry,  struct nameidata *nd)
{

  int nodirs;
  int k;
  struct vvsfs_inode dirdata;
  struct inode *inode = NULL;
  struct vvsfs_dir_entry *dent;

  if (DEBUG) printk("vvsfs - lookup\n");


  vvsfs_readblock(dir->i_sb,dir->i_ino,&dirdata);
  nodirs = dirdata.size/sizeof(struct vvsfs_dir_entry);

  for (k=0;k<nodirs;k++) {
    dent = (struct vvsfs_dir_entry *) ((dirdata.data) + k*sizeof(struct vvsfs_dir_entry));
    
    if ((strlen(dent->name) == dentry->d_name.len) && 
	strncmp(dent->name,dentry->d_name.name,dentry->d_name.len) == 0) {
      inode = iget(dir->i_sb, dent->inode_number);
 
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
static int vvsfs_empty_inode(struct super_block *sb) {
  struct vvsfs_inode block;
  int k;
  for (k =0;k<NUMBLOCKS;k++) {
    vvsfs_readblock(sb,k,&block);
    if (block.is_empty) return k;   
  }
  return -1;
}

// vvsfs_new_inode - find and construct a new inode.
struct inode * vvsfs_new_inode(const struct inode * dir)
{
  struct vvsfs_inode block;
  struct super_block * sb;
  struct inode * inode;
  int newinodenumber;

  if (DEBUG) printk("vvsfs - new inode\n");
  
  sb = dir->i_sb;

  /* get an vfs inode */
  if (!dir || !(inode = new_inode(sb)))
    return NULL;
 
  inode->i_sb = sb;
  inode->i_flags = 0;
  
 
  /* find a spare inode in the vvsfs */
  newinodenumber = vvsfs_empty_inode(sb);
  if (newinodenumber == -1) {
    printk("vvsfs - inode table is full.\n");
    return NULL;
  }
  
  block.is_empty = false;
  block.size = 0;
  block.is_directory = false;
  
  vvsfs_writeblock(sb,newinodenumber,&block);
  

  inode->i_ino = newinodenumber;
  
  inode->i_nlink = 1;
  inode->i_size = 0;
  
  inode->i_uid = 0;
  inode->i_gid = 0;
  
  inode->i_ctime = inode->i_mtime = inode->i_atime = CURRENT_TIME;
  
   
  inode->i_mode = S_IRUGO|S_IWUSR|S_IFREG;
  inode->i_op = NULL;
  
  insert_inode_hash(inode);
  
  return inode;
}

// vvsfs_create - create a new file in a directory 
static int
vvsfs_create(struct inode *dir,struct dentry* dentry,int mode, struct nameidata *nd) {

  struct vvsfs_inode dirdata;
  int nodirs;
  struct vvsfs_dir_entry *dent;

  struct inode * inode;

  if (DEBUG) printk("vvsfs - create : %s\n",dentry->d_name.name);

  inode = vvsfs_new_inode(dir);
  if (!inode)
    return -ENOSPC;
  inode->i_op = &vvsfs_file_inode_operations;
  inode->i_fop = &vvsfs_file_operations;
  inode->i_mode = mode;

  /* get an vfs inode */
  if (!dir) return -1;

  vvsfs_readblock(dir->i_sb,dir->i_ino,&dirdata);
  nodirs = dirdata.size/sizeof(struct vvsfs_dir_entry);
  dent = (struct vvsfs_dir_entry *) ((dirdata.data) + nodirs*sizeof(struct vvsfs_dir_entry));

  strncpy(dent->name, dentry->d_name.name,dentry->d_name.len);
  dent->name[dentry->d_name.len] = '\0';
  

  dirdata.size = (nodirs + 1) * sizeof(struct vvsfs_dir_entry);
 

  dent->inode_number = inode->i_ino;

  
  vvsfs_writeblock(dir->i_sb,dir->i_ino,&dirdata);

  d_instantiate(dentry, inode);

  printk("File created %ld\n",inode->i_ino);
  return 0;
}

// vvsfs_file_write - write to a file
static ssize_t
vvsfs_file_write(struct file *filp, const char *buf, size_t count, loff_t *ppos)
{
  struct vvsfs_inode filedata; 
  struct inode *inode = filp->f_dentry->d_inode;
  ssize_t pos;
  struct super_block * sb;
  char * p;

  if (DEBUG) printk("vvsfs - file write - count : %d ppos %Ld\n",count,*ppos);

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
 
  
  if (DEBUG) printk("vvsfs - file write done : %d ppos %Ld\n",count,*ppos);
  
  return count;
}


// vvsfs_file_read - read data from a file
static ssize_t
vvsfs_file_read(struct file *filp, char *buf, size_t count, loff_t *ppos)
{

  struct vvsfs_inode filedata; 
  struct inode *inode = filp->f_dentry->d_inode;
  char                    *start;
  ssize_t                  offset, size;

  struct super_block * sb;
  
  if (DEBUG) printk("vvsfs - file read - count : %d ppos %Ld\n",count,*ppos);



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

  printk("r : readblock\n");
  vvsfs_readblock(sb,inode->i_ino,&filedata);


  start = buf;
   printk("rr\n");
  size = MIN (inode->i_size - *ppos,count);

 printk("readblock : %d\n", size);
  offset = *ppos;            
  *ppos += size;

 printk("r copy_to_user\n");

  if (copy_to_user(buf,filedata.data + offset,size)) 
    return -EIO;
  buf += size;
  
  printk("r return\n");
  return size;
}


static struct file_operations vvsfs_file_operations = {
        read: vvsfs_file_read,        /* read */
        write: vvsfs_file_write,       /* write */
};


static struct inode_operations vvsfs_file_inode_operations = {
};

static struct file_operations vvsfs_dir_operations = {
 readdir:        vvsfs_readdir,          /* readdir */
};

static struct inode_operations vvsfs_dir_inode_operations = {
   create:     vvsfs_create,                   /* create */
   lookup:     vvsfs_lookup,           /* lookup */
};


// vvsfs_read_inode - read an inode from the block device
static void
vvsfs_read_inode(struct inode *i)
{

  struct vvsfs_inode filedata; 
  
  if (DEBUG) {
    printk("vvsfs - read inode - ino : %d", (unsigned int) i->i_ino);
    printk(" inode %x",(unsigned int) i);
    printk(" super %x\n",(unsigned int) i->i_sb);  
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
  printk("inode %x\n",(unsigned int) i);


  hblock = bdev_hardsect_size(s->s_bdev);
  if (hblock > BLOCKSIZE) {
    
     printk("device blocks are too small!!");
     return -1;
  }

  set_blocksize(s->s_bdev, BLOCKSIZE);
  s->s_blocksize = BLOCKSIZE;
  s->s_blocksize_bits = BLOCKSIZE_BITS;


  s->s_root = d_alloc_root(i);           /*2.4*/

  return 0;
}



static struct super_operations vvsfs_ops = {
  read_inode: vvsfs_read_inode,
  statfs: vvsfs_statfs,
  put_super: vvsfs_put_super,
};

static struct super_block *vvsfs_get_sb(struct file_system_type *fs_type,
        int flags, const char *dev_name, void *data, struct vfsmount *mnt)
{
        return get_sb_bdev(fs_type, flags, dev_name, data, vvsfs_fill_super, mnt);
}

static struct file_system_type vvsfs_type = {
        .owner          = THIS_MODULE,
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


















