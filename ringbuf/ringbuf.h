#ifndef RINGBUF_H
#define RINGBUF_H

#include <stdbool.h>
#include <sys/types.h>
#include "eruutil/erudebug.h"

typedef struct {
	void *buf;
	volatile size_t w, r;
	size_t size;
} RingBuf;

RingBuf *ring_new(size_t);
void ring_end(RingBuf *);
#define ring_size(rb) (rb->size - 1)
size_t ring_space(RingBuf *);
size_t ring_pending(RingBuf *);
size_t ring_write(RingBuf *, const void *, size_t);
size_t ring_read(RingBuf *, void *, size_t);

#endif
