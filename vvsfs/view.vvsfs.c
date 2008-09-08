

/* view.vvsfs - print a summary of the data in the entire file system
   Eric McCreath 2006 GPL */

/* To compile :
     gcc view.vvsfs.c -o view.vvsfs

*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "vvsfs.h"

char* device_name;
int device;

static void die(char *mess) {
  fprintf(stderr,"Exit : %s\n",mess);
  exit(1);
}

static void usage(void) {
   die("Usage : view.vvsfs <device name>)");
}

int main(int argc, char ** argv) {
  if (argc != 2) usage();

  // open the device for reading
  device_name = argv[1];
  device = open(device_name,O_RDONLY);
  
  off_t pos=0;
  struct vvsfs_inode inode;
  int i;
  for (i = 0; i < NUMBLOCKS; i++) {  // read each of the blocks

    if (pos != lseek(device,pos,SEEK_SET)) 
      die("seek set failed");
    if (sizeof(struct vvsfs_inode) != read(device,&inode,sizeof(struct vvsfs_inode))) 
      die("inode read failed");

    printf("%2d : empty : %s dir : %s size : %i data : ", i, 
                       (inode.is_empty?"T":"F"), 
                       (inode.is_directory?"T":"F"), 
                       inode.size);


    if (inode.is_directory) {
      int k, nodirs;
      struct vvsfs_dir_entry *dent;
      nodirs = inode.size/sizeof(struct vvsfs_dir_entry);
      for (k=0;k<nodirs;k++) {
	dent = inode.data + k*sizeof(struct vvsfs_dir_entry);
        printf("%s : %d ",dent->name, dent->inode_number);
      }
      printf("\n");
    } else {
       int j;
       for (j=0;j< inode.size;j++) {
         if (inode.data[j] == '\n') {
           printf("\\n");
	 } else {
           printf("%lc",inode.data[j]);
	 }
       }
       printf("\n");   

    }
    pos += sizeof(struct vvsfs_inode);
  }
  close(device);
  return 0;
}

