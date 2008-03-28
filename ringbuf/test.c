#include "ringbuf.h"
#include <stdio.h>
#include <error.h>
#include <assert.h>
#include <string.h>

static_assert(sizeof(size_t) == 4);

int main()
{
	psize(RingBuf);
	RingBuf *rb = ring_new(10);
	dump(ring_size(rb), "%u");
	dump(ring_space(rb), "%u");
	dump(ring_pending(rb), "%u");
	char s1[] = "hello";
	char s2[] = " ";
	char s3[] = ":)";
	ring_write(rb, s1, strlen(s1));
	ring_write(rb, s2, strlen(s2));
	ring_write(rb, s3, strlen(s3) + 1);
	dump(ring_space(rb), "%u");
	char o1[10];
	verify(ring_read(rb, o1, 10) == 9);
	debugln(o1);
	dump(ring_space(rb), "%u");
	verify(ring_write(rb, s1, strlen(s1)) == 5);
	verify(ring_write(rb, s1, strlen(s1)) == 5);
	verify(ring_read(rb, o1, 1) == 1);
	verify(ring_write(rb, s2, 1) == 1);
	dump(ring_space(rb), "%u");
	verify(ring_read(rb, s1, 3) == 3);
	verify(ring_write(rb, s3, 3) == 3);
	verify(ring_read(rb, o1 + 1, 10) == 10);
	debugln(o1);
	verify(ring_write(rb, rb->buf, 15) == 10);
	dump(ring_space(rb), "%u");
	dump(ring_pending(rb), "%u");
	dump(ring_size(rb), "%u");
	ring_end(rb);
	return 0;
}
