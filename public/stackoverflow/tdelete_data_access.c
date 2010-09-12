#include <assert.h>
#include <search.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
make -B tdelete_data_access CFLAGS='-g -std=gnu99 -Wall'
valgrind --leak-check=full --track-fds=yes ./tdelete_data_access /home/matt/cpfs/cpfs.s
*/

static inline int tree_strcmp(void const *left, void const *right)
{
    return strcmp(left, right);
}

int main(int argc, char *argv[])
{
    void *root = NULL;
    FILE *fp = fopen(argv[1], "r+b");
    assert(fp);
    char line[0x1000];
    // add all lines of file
    for (size_t lno = 1; fgets(line, sizeof(line), fp); ++lno)
    {
        char *key = strdup(line);
        if (*(char **)tsearch(key, &root, tree_strcmp) != key)
        {
            //printf("line %zu is duplicate of previous line\n", lno);
            free(key);
        }
    }
    // delete the entire tree
    while (root)
    {
        char *data = *(char **)root;
        assert(tdelete(data, &root, tree_strcmp));
        free(data);
    }
    fclose(fp);
    return 0;
}
