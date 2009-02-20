#include <sys/types.h>
#include <attr/xattr.h>
#include "eruutil/erudebug.h"

static_assert(sizeof(ssize_t) == sizeof(long));

int main(int argc, char *argv[])
{
	ssize_t listsize = listxattr(argv[1], NULL, 0);
	if (listsize == -1) fatal(errno, "listxattr()");
	dump(listsize, "%ld");
	if (setxattr(argv[1], "user.hi", "penis", 6, 0)) fatal(errno, "setxattr()");
	return 0;
}
