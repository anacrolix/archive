#include <stdlib.h>
#include <stdio.h>

/* About DYNAMIC:
 * DYNAMIC here is used to decide which part of the code to execute.
 * When DYNAMIC is defined, we dynamically load libmatt-shared.so and
 * obtain the address of "hello" in memory. If DYNAMIC is not defined,
 * then it is assumed that usematt is linked statically or at load time, and
 * the address is determined at compile time by the linker.
 */

#ifdef DYNAMIC
	#include <assert.h>
	#include <dlfcn.h>
	void (*hello)(int);
#else
	#include "libmatt.h"
#endif

/* __attribute__((noreturn)) tells GCC that this function is never returned
 * from. It has no effect on this example except to show how cool I am.
 */
__attribute__((noreturn)) void usage(const char *progname)
{
	printf("Usage: %s <int>\n", progname);
	exit(EXIT_SUCCESS);
}

int main(int argc, char *argv[])
{
	if (argc != 2)
		usage(argv[0]);
#ifdef DYNAMIC
		void *handle = dlopen("libmatt-shared.so", RTLD_LAZY);
		assert(handle);
		dlerror();
		hello = dlsym(handle, "hello");
		assert(!dlerror());
		(*hello)(atoi(argv[1]));
		dlclose(handle);
#else
		hello(atoi(argv[1]));
#endif
	return EXIT_SUCCESS;
}
