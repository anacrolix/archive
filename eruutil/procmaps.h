#include <sys/types.h>
#include <stdbool.h>

typedef struct {
	void *start, *end;
	char perms[4];
	off_t offset;
	unsigned char major, minor;
	ino_t inode;
	char path[0x100];
} procmap_t;

void print_proc_maps(procmap_t *maps, int count);
bool get_proc_maps(pid_t pid, procmap_t **maps, int *count);
