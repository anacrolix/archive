#include "botutil.h"

int main(int argc, char **argv)
{
	struct timespec monotime;
	verify(0 == clock_gettime(CLOCK_MONOTONIC, &monotime));
	assert(monotime.tv_nsec >= 0 && monotime.tv_nsec <= 999999999);
	printf("%ld.%09ld\n", monotime.tv_sec, monotime.tv_nsec);
	return 0;
}
