#include "procmaps.h"
#include <unistd.h>
#include <sys/types.h>
#include <error.h>
#include <assert.h>
#include <stdlib.h>
#include "debug.h"

int main()
{
	pid_t mypid = getpid();
	trace("%d", mypid);
	procmap_t *maps;
	int mapcount;
	verify(get_proc_maps(mypid, &maps, &mapcount));
	print_proc_maps(maps, mapcount);
	return EXIT_SUCCESS;
}

//#define _BSD_SOURCE
//#include <stdlib.h>
//#include <limits.h>
//#include <stdio.h>
//#include <sys/mman.h>
//#include <sys/stat.h>
//#include <errno.h>
//#include <unistd.h>
//#include <fcntl.h>
//#include <error.h>
//#include <string.h>
//#include <assert.h>
//#include "erudebug.h"
//#include "bit.h"

//int main(int argc, char *argv[])
//{
	//unsigned char buf[] = {0xff, 0xfa, 0xe3, 0, 0xc4};
	//struct bitptr bp;
	//bit_init(&bp, buf);
	//for (int i = 0; i < CHAR_BIT * 5; i++) {
		//if (bit_read(&bp, 1)) {
			//putchar('1');
		//} else {
			//putchar('0');
		//}
		//if (i % CHAR_BIT == CHAR_BIT - 1 && i != 0)
			//putchar(' ');
	//}
	//putchar('\n');
	//bit_finish(&bp);

	//bit_init(&bp, buf);
	//struct {
		//unsigned sync;
		//unsigned version;
		//unsigned layer;
	//} framehdr;
	//framehdr.sync = bit_read(&bp, 11);
	//framehdr.version = bit_read(&bp, 2);
	//framehdr.layer = bit_read(&bp, 2);
	//bit_finish(&bp);
	//if (framehdr.sync != 0x7ff || framehdr.version != 3 || framehdr.layer != 1) {
		//puts("beep");
		//return 1;
	//}
	//bit_skip(&bp, 17);
	//printf("%lx\n", bit_read(&bp, 8));

	//int fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0644);
	//if (fd == -1) {
		//warn(errno, "open()");
		//return 1;
	//}
	///*
	//if (ftruncate(fd, 160000)) {
		//warn(errno, "ftruncate()");
		//return 1;
	//}
	//*/
	////struct stat stat;
	////if (fstat(fd, &stat) == -1) {
	////	warn(errno, "fstat()");
	////	return 1;
	////}
	//char *fdm = mmap(NULL, 160000, PROT_WRITE | PROT_READ, MAP_SHARED, fd, 0);
	//if (fdm == MAP_FAILED) {
		//warn(errno, "mmap()");
		//return 1;
	//}
	//for (int i = 0; i < 160000; i++) {
		//fdm[i] = 'h';
	//}
	////printf("enter replacement tag!! ");
	////char tag[3];
	////scanf("%3c", tag);
	////assert(strlen(tag) == 3);
	////memcpy(fdm, tag, 3);
	//if (munmap(fdm, 140000)) {
		//warn(errno, "munmap()");
		//return 1;
	//}
	////printf("%s\n", tag);
	//if (close(fd) == -1) {
		//warn(errno, "close()");
		//return 1;
	//}

	//printf("Test passed.\n");

	//verify(printf("hi ;D\n") == 5);
	//return 0;
//}
