//#define _SVID_SOURCE
#define _BSD_SOURCE

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

#define	fatal(errval, fmt, ...) (error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#define debug(fmt, ...) (fprintf(stderr, fmt, ##__VA_ARGS__))

void chomp(char *str, char c)
{
	int len = strlen(str);
	if (str[len - 1] == c)
		str[len - 1] = '\0';
}

char *join(const char *delimit, int count, ...)
{
	// retrieve all the argument strings
	char *args[count];
	assert(sizeof(args) == count * sizeof(char *));
	va_list argp;
	va_start(argp, count);
	for (int i = 0; i < count; i++)
		args[i] = va_arg(argp, char *);	
	va_end(argp);
	
	// allocate space for output string
	size_t size = 0;
	for (int i = 0; i < count; i++)
		size += strlen(args[i]);
	size += strlen(delimit) * (count - 1);
	size += 1; // term char
	char *out = malloc(size);
	if (out == NULL) fatal(errno, "malloc()");
	out[0] = '\0';
	
	// create output string
	for (int i = 0; i < count - 1; i++) {
		strcat(out, args[i]);
		strcat(out, delimit);
	}
	strcat(out, args[count - 1]);
	assert(strlen(out) + 1 == size);
	return out;
}

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
	assert(sizeof(off_t) == sizeof(int));
	printf("%d\t%s\n", sumsize, argv[1]);
	return EXIT_SUCCESS;
}
