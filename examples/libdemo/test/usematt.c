#include <stdlib.h>
#include <stdio.h>

/* About DYNAMIC:
 * DYNAMIC here is used to decide which part of the code to execute.
 * When DYNAMIC is defined, we dynamically load libmatt-shared.so and
 * obtain the address of "hello" in memory. If DYNAMIC is not defined,
 * then it is assumed that usematt is linked statically or at load time, and
 * the address is determined at compile time by the linker.
 */

#if defined(DYNAMIC)
#	if defined(_WIN32)
#		include <Windows.h>
#	else
#		include <dlfcn.h>
#	endif
#	include <assert.h>
	void (*hello)(int);
#else
#	include "libmatt.h"
#endif


#if defined(_MSC_VER)
#	define NORETURN __declspec(noreturn)
#else
#	define NORETURN __attribute((noreturn))
#endif

/* __attribute__((noreturn)) tells GCC that this function is never returned
 * from. It has no effect on this example except to show how cool I am.
 */
NORETURN void usage(const char *progname)
{
	printf("Usage: %s <int>\n", progname);
	exit(EXIT_SUCCESS);
}

void press_any_key(void)
{
#if defined(_WIN32)
	system("pause");
#endif
}

int main(int argc, char *argv[])
{
#if defined(DYNAMIC)
	HMODULE handle;
#endif
	atexit(press_any_key);
	if (argc != 2)
		//usage(argv[0]);
		argv[1] = "-1";
#if defined(DYNAMIC)
#	if defined(_WIN32)
	//assert(SetDllDirectory("../src") != FALSE);
	handle = LoadLibrary("libmatt.dll");
	assert(handle != NULL);
	hello = (void(*)(int))GetProcAddress(handle, "hello");
	assert(hello != NULL);
	(*hello)(atoi(argv[1]));
	assert(FreeLibrary(handle) != FALSE);
#	else
	void *handle = dlopen("libmatt-shared.so", RTLD_LAZY);
	assert(handle);
	dlerror();
	hello = dlsym(handle, "hello");
	assert(!dlerror());
	(*hello)(atoi(argv[1]));
	dlclose(handle);
#	endif
#else
	hello(atoi(argv[1]));
#endif
	return EXIT_SUCCESS;
}
