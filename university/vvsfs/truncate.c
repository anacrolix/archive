#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>


main(int argc, char *argv[]) {

  int dfile, filesize;

  if (argc != 3) {
    printf("usage : truncate <name> <size>\n");
    return 1;
  }

  dfile = open(argv[1],O_RDWR|O_CREAT);

  if (sscanf(argv[2],"%d",&filesize) != 1) {
    printf("Problem with number format\n");
    return -1;

  }

  
  if (ftruncate(dfile,filesize)) {
    printf("Problem with ftruncate\n");
    return -1;
  }


}
