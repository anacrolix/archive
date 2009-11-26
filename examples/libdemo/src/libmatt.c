#include <stdio.h>

#if defined(_MSC_VER)
#	define DLLEXPORT __declspec(dllexport)
#else
#	define DLLEXPORT
#endif

DLLEXPORT void hello(int val)
{
	printf("Hello, the value was %d\n", val);
}
