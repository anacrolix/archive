#ifndef BIT_H
#define BIT_H

struct bitptr {
	const unsigned char *byte;
	unsigned short cache;
	unsigned short left;
};

void bit_init(struct bitptr *, const unsigned char *);
#define bit_finish(bitptr)
void bit_skip(struct bitptr *, unsigned);
unsigned long bit_read(struct bitptr *, unsigned);

#endif
