#include "ringbuf.h"
#include <stdlib.h>
#include <assert.h>
#include <string.h>

RingBuf *ring_new(size_t size)
{
	RingBuf *rb = malloc(sizeof(RingBuf));
	if (!rb) goto fail;
	rb->buf = malloc(++size);
	if (!rb->buf) goto fail;
	rb->w = 0;
	rb->r = 0;
	rb->size = size;
	return rb;
fail:
	assert(!rb->buf);
	if (rb) free(rb);
	return NULL;
}

void ring_end(RingBuf *rb)
{
	assert(rb);
	assert(rb->buf);
	free(rb->buf);
	free(rb);
}

size_t ring_space(RingBuf *rb)
{
	if (rb->w > rb->r) return rb->size - (rb->w - rb->r) - 1;
	else if (rb->w < rb->r) return rb->r - rb->w - 1;
	else if (rb->w == rb->r) return rb->size - 1;
	else assert(false);
}

size_t ring_pending(RingBuf *rb)
{
	return rb->size - ring_space(rb) - 1;
}

size_t ring_write(RingBuf *rb, const void *src, size_t n)
{
	// truncate input to available space
	size_t space = ring_space(rb);
	if (space < n) n = space;
	// determine writes to perform
	size_t write1, write2;
	if (rb->w + n > rb->size) {
		write1 = rb->size - rb->w;
		write2 = n - write1;
	} else {
		write1 = n;
		write2 = 0;
	}
	assert(write1 + write2 == n);
	// write to end of buffer
	verify(memcpy(rb->buf + rb->w, src, write1) == rb->buf + rb->w);
	rb->w = (rb->w + write1) % rb->size;
	if (write2) {
		assert(rb->w == 0);
		src += write1;
		verify(memcpy(rb->buf, src, write2) == rb->buf);
		rb->w = write2;
	}
	return n;
}

size_t ring_read(RingBuf *rb, void *dest, size_t n)
{
	// truncate output to best of available space and data
	size_t avail = ring_pending(rb);
	if (avail < n) n = avail;
	// determine reads to perform
	size_t read1, read2;
	if (rb->r + n > rb->size) {
		read1 = rb->size - rb->r;
		read2 = n - read1;
	} else {
		read1 = n;
		read2 = 0;
	}
	assert(read1 + read2 == n);
	// read up to the end of the buffer
	verify(memcpy(dest, rb->buf + rb->r, read1) == dest);
	rb->r = (rb->r + read1) % rb->size;
	if (read2) {
		// read from beginning of buffer
		assert(rb->r == 0);
		dest += read1;
		verify(memcpy(dest, rb->buf, read2) == dest);
		rb->r = read2;
	}
	return n;
}
