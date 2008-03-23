#include <limits.h>
#include "bit.h"

void bit_init(struct bitptr *bp, const unsigned char *byte)
{
	bp->byte = byte;
	bp->cache = 0;
	bp->left = CHAR_BIT;
}

#if 0
void bit_finish(struct bitptr *bp) {}
#endif

void bit_skip(struct bitptr *bp, unsigned len)
{
	bp->byte += len / CHAR_BIT;
	bp->left -= len % CHAR_BIT;

	if (bp->left > CHAR_BIT) {
		bp->byte++;
		bp->left += CHAR_BIT;
	}

	if (bp->left < CHAR_BIT)
		bp->cache = *bp->byte;
}

unsigned long bit_read(struct bitptr *bp, unsigned len)
{
	register unsigned long value;

	if (bp->left == CHAR_BIT)
		bp->cache = *bp->byte;

	if (len < bp->left) {
		value = (bp->cache & ((1 << bp->left) - 1)) >> (bp->left - len);
		bp->left -= len;
		return value;
	}

	value = bp->cache & ((1 << bp->left) - 1);
	len -= bp->left;

	bp->byte++;
	bp->left = CHAR_BIT;

	while (len >= CHAR_BIT) {
		value = (value << CHAR_BIT) | *bp->byte++;
		len -= CHAR_BIT;
	}

	if (len > 0) {
		bp->cache = *bp->byte;
		value = (value << len) | (bp->cache >> (CHAR_BIT - len));
		bp->left -= len;
	}

	return value;
}
