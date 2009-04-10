#include "demo_b.h"
#include <assert.h>
//#include <stdio.h>
#include <stdlib.h>

int main()
{
    if (extfunc() == 42) {
        puts("PROGRAM SUCCESS");
        return EXIT_SUCCESS;
    }
    else {
        puts("PROGRAM FAILURE");
        assert(0);
        return EXIT_FAILURE;
    }
}
