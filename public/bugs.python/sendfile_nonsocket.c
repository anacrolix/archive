#include <sys/sendfile.h>
#include <fcntl.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int in_fd = open(argv[1], O_RDONLY);
    int out_fd = open(argv[2], O_WRONLY | O_CREAT, 0666);
    off_t offset = 0;
    ssize_t zdret = splice(in_fd, NULL, out_fd, NULL, 1, 0);
    //printf("sendfile(out_fd=%d, in_fd=%d, offset=%ld, count=%zu) = %zd\n",
    //    out_fd, in_fd, offset, (size_t)-1, zdret);
    //if
    return 0;
}
