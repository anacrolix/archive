#include <stdlib.h>
#include <limits.h>
#include <stdio.h>
#include "bit.h"

int main()
{
	unsigned char buf[] = {0xff, 0xfa, 0xe3, 0, 0xc4};
	struct bitptr bp;
	bit_init(&bp, buf);
	for (int i = 0; i < CHAR_BIT * 5; i++) {
		if (bit_read(&bp, 1)) {
			putchar('1');
		} else {
			putchar('0');
		}
		if (i % CHAR_BIT == CHAR_BIT - 1 && i != 0)
			putchar(' ');
	}
	putchar('\n');
	bit_finish(&bp);

	bit_init(&bp, buf);
	struct {
		unsigned sync;
		unsigned version;
		unsigned layer;
	} framehdr;
	framehdr.sync = bit_read(&bp, 11);
	framehdr.version = bit_read(&bp, 2);
	framehdr.layer = bit_read(&bp, 2);
	bit_finish(&bp);
	if (framehdr.sync != 0x7ff || framehdr.version != 3 || framehdr.layer != 1) {
		puts("beep");
		return 1;
	}
	bit_skip(&bp, 17);
	printf("%x\n", bit_read(&bp, 8));

	printf("Test passed.\n");

	return 0;
}
