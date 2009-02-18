#include <stdio.h>

void swap(long *a, long *b)
{
	long c = *a;
	*a = *b;
	*b = c;
	printf("swapped a and b\n");
}

void swap2(long *a, long *b)
{
	asm volatile(
		"movq (%0), %%rax;"
		"movq (%1), %%rbx;"
		"movq %%rax, (%1);"
		"movq %%rbx, (%0);"
		:
		: "r"(a), "r"(b)
		: "%rax", "%rbx"
	);
}

int main()
{
	long a = 3, b = 5;
	printf("a: %ld, b: %ld\n", a, b);
	swap2(&a, &b);
	printf("a: %ld, b: %ld\n", a, b);
	asm("movq $1, %rax; int $0x80");
	return 0;
}
