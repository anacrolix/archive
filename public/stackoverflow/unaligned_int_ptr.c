#include <stdio.h>

int main()
{
    int a[2] = {0, 1};
    printf("%x\n", *(int *)(((char *)&a[0]) + 1));
    return 0;
}
