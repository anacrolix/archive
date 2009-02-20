#include <unistd.h>
#include "eruutil/erudebug.h"

int main()
{
	dump(sbrk(0), "%p");
	void *mem = malloc(sizeof(long));
	dump(mem, "%p");
	dump(sbrk(0), "%p");
	free(mem);
	dump(sbrk(0), "%p");
	return 0;
}
