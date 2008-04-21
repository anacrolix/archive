#ifdef DYNAMIC
	#include <assert.h>
	#include <dlfcn.h>
	void (*hello)(int);
#else
	#include "libmatt.h"
#endif
#include <stdlib.h>
#include <stdio.h>

__attribute__((noreturn)) void usage(const char *progname)
{
	printf("Usage: %s <int>\n", progname);
	exit(EXIT_SUCCESS);
}

int main(int argc, char *argv[])
{
	if (argc != 2) usage(argv[0]);
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
