#include <stdlib.h>
#include <stdio.h>

#define offsetof(a,b) __builtin_offsetof(a,b)

#define container_of(ptr, type, member) ({			\
	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
	(type *)( (char *)__mptr - offsetof(type,member) );})

struct list {
	struct list *next;
};

struct dummy {
	int value;
	struct list link;
};

int main()
{
	struct dummy a = {3, {0}};
	struct dummy b = {5, {&a.link}};
	printf("%d\n", container_of(b.link.next, struct dummy, link)->value);
	return 0;
}
