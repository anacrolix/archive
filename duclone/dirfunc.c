//#define _SVID_SOURCE
#define _BSD_SOURCE
#define _FILE_OFFSET_BITS 64

#include <dirent.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>
#include <sys/stat.h>
#include <unistd.h>
#include <assert.h>
#include <error.h>
#include "../eruutil/perlfunc.h"
#include "../eruutil/erudebug.h"

void usage(const char *progname)
{
	printf("Usage: %s <dirpath>\n", progname);
	exit(EXIT_FAILURE);
}

void parsedir(const char *dirname, int depth, off_t *size)
{
	DIR *dir = opendir(dirname);
	if (dir == NULL)
		fatal(errno, "opendir()");
	if (depth == 0) {
		assert(*size == 0);
		struct stat s;
		if (lstat(dirname, &s))
			fatal(errno, "lstat()");
		*size += s.st_size;
	}
	struct dirent *dirent;
	while ((dirent = readdir(dir))) {
		if (!strcmp(dirent->d_name, ".") || !strcmp(dirent->d_name, ".."))
			continue;
		assert(_D_EXACT_NAMLEN(dirent) == strlen(dirent->d_name));
		char *fullname = join("/", 2, dirname, dirent->d_name);
		struct stat entstat;
		if (lstat(fullname, &entstat))
			fatal(errno, "lstat()");
		*size += entstat.st_size;
		if (S_ISDIR(entstat.st_mode)) {
			off_t subsize = 0;
			parsedir(fullname, depth + 1, &subsize);
			*size += subsize;
		}		
		free(fullname);
	}
	if (closedir(dir))
		fatal(errno, "closedir()");
}

int main(int argc, char *argv[])
{
	if (argc != 2)
		usage(argv[0]);
	chomp(argv[1], '/');
	off_t sumsize = 0;
	parsedir(argv[1], 0, &sumsize);
	assert(sizeof(off_t) == sizeof(long long int));
	printf("%lld\t%s\n", sumsize, argv[1]);
	return EXIT_SUCCESS;
}
