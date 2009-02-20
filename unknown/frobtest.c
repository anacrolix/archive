#define _GNU_SOURCE
#include <string.h>
#include <limits.h>
#include <stdio.h>

#define FROBSIZE UCHAR_MAX+1

int main()
{
	unsigned char a[FROBSIZE], b[FROBSIZE];
	for (int i = 0; i < FROBSIZE; i++) {
		a[i] = i;
		b[i] = i;
	}
	memfrob(b, sizeof(b));
	//memfrob(b, sizeof(b));
	for (int i = 0; i < FROBSIZE; i++) {
		printf("%3hhx%3hhx\n", a[i], b[i]);
	}
	return 0;
}
