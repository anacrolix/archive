#include <sys/mman.h>
#include <assert.h>
#include <stdio.h>

size_t const zeroed_size = 512;
char const *zeroed;

int main()
{
    zeroed = mmap(
            NULL,
            zeroed_size,
            PROT_READ,
            MAP_PRIVATE|MAP_ANONYMOUS,
            -1,
            0);
    printf("zeroed region at %p\n", zeroed);
    for (size_t i = 0; i < zeroed_size; ++i) {
        assert(zeroed[i] == 0);
    }
    printf("testing for writability\n");
    ((char *)zeroed)[0] = 1;
    return 0;
}
