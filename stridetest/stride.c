#include <stdio.h>
#include <sys/times.h>
#include <unistd.h>
#include "eruutil/erudebug.h"

#define DATASIZE 4096 * 4096 * 16

static_assert(sizeof(clock_t) == sizeof(long int));

// call times() or die
inline void xtimes(struct tms *tms)
{
	if (times(tms) == (clock_t)-1) fatal(errno, "times()");
}

// call malloc() or die
inline void *xmalloc(size_t size)
{
	void *ret = malloc(size);
	if (ret == NULL && size != (size_t)0) fatal(errno, "malloc()");
	return ret;
}

// time accessing datalen bytes, striding by stride bytes
clock_t time_stride(
	size_t const datalen,
	long unsigned const stride)
{
	// decide on a data type to use througout the function
	typedef long datatype_t;
	// check stride is a multiple of the size of our type
	assert(stride % sizeof(datatype_t) == 0);
	// datalen must be a multiple of the stride
	assert(datalen % stride == 0);
	// check that things add up
	assert((stride / sizeof(datatype_t)) * (datalen / stride) * sizeof(datatype_t) == datalen);
	
	datatype_t *data = xmalloc(datalen);
	
	// check that all allocated bytes are not already set to 1
	// (this would invalidate the check later)
	for (long unsigned i = 0; i < datalen / sizeof(datatype_t); i++) {
		if (data[i] != 1) break;
		assert(i < datalen / sizeof(datatype_t) - 1);
	}
		
	// stride through the data, setting it
	struct tms tms_before;
	xtimes(&tms_before);
	for (long unsigned i = 0; i < stride / sizeof(datatype_t); i++) {
		for (long unsigned j = 0; j < datalen / stride; j++) {
			data[j * stride / sizeof(datatype_t) + i] = 1;
		}
	}
	struct tms tms_after;
	xtimes(&tms_after);
	
	// check that all allocated bytes were written correctly
	for (long unsigned i = 0; i < datalen / sizeof(datatype_t); i++) {
		assert(data[i] == 1);
	}
	
	free(data);
	return tms_after.tms_utime - tms_before.tms_utime;
}

int main()
{
	dump(time_stride(DATASIZE, sizeof(long)), "%ld");
	dump(time_stride(DATASIZE, 16 * sizeof(long)), "%ld");
	dump(time_stride(DATASIZE, sizeof(long)), "%ld");
	return 0;
}
