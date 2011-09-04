#include <stdio.h>
#include <stdlib.h>

#define MAX_VALS 3

int valscmp(void const *left, void const *right)
{
    return *(int *)left - *(int *)right;
}

void main()
{
    int vals[MAX_VALS];
    int count = 0;
    while (1 == scanf("%d", &vals[count]) && count < MAX_VALS)
        ++count;
    qsort(vals, count, sizeof(*vals), valscmp);
    for (int i = 0; i < count; ++i)
        printf("%d ", vals[i]);
    putchar('\n');
}
