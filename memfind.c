#include <stdio.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdarg.h>

typedef unsigned int uint;

struct mem_region {
  void *address;
  void *data;
  uint size;
};

void proc_detach(pid_t pid) {
  if (ptrace(PTRACE_DETACH, pid, NULL, NULL) != 0) {
    perror("ptrace() detach");
    exit(EXIT_FAILURE);
  }
}  

int proc_attach(pid_t pid) {
  if (ptrace(PTRACE_ATTACH, pid, NULL, NULL) && errno) {
    perror("ptrace() attach");
    return 1;
  }
  if (waitpid(pid, NULL, 0) != pid) {
    perror("waitpid() for first attached signal");
    proc_detach(pid);
    return 1;
  }
}

char *mprintf(const char *fmt, ...) {
  va_list args; //variadic parameters
  char *s, ns; //output string and new string for realloc
  size_t size = 100; //initial output string buffer size
  int n; //length of printed string
  if ((s = malloc(size)) == NULL)
    return NULL;
  while (!0) {
    va_start(args, fmt);
    n = vsnprintf(s, size, fmt, args);
    va_end(args);
    if (n > -1 && n < size)
      return realloc(s, n + 1);
    if (n > -1)
      size = n + 1;
    else
      size *= 2;
    if ((ns = realloc(s, size)) == NULL) {
      free(s);
      return NULL;
    } else {
      s = ns;
    }
  }
  return NULL;
}

void perrquit(char *errmsg) {
  perror(errmsg);
  exit(EXIT_FAILURE);
}

int mem_read(void *buf, pid_t pid, off_t beg, size_t size) {
  char *mempath = mprintf("/proc/%d/mem", pid);
  proc_attach(pid);
  int memfile = open(mempath, O_RDWR);
  free(mempath);
  if (memfile == -1) {
    perror("open() mem file");
    proc_detach(pid);
    return 1;
  }
  if (lseek(memfile, beg, SEEK_SET) == -1) {
    perror("lseek()");
    close(memfile);
    proc_detach(pid);
    return 1;
  }
  if (read(memfile, buf, size) != size) {
    perror("read()");
    close(memfile);
    proc_detach(pid);
    return 1;
  }
  close(memfile);
  proc_detach(pid);
  return 0;
}

int mem_watch(pid_t pid, off_t beg, size_t size, uint interval) {
  int *buf1, *buf2, *tmp;
  buf1 = malloc(size);
  buf2 = malloc(size);
  mem_read(buf1, pid, beg, size);
  while (1) {
    mem_read(buf2, pid, beg, size);
    uint i;
    for (i = 0; i < size / sizeof(int); i++) {
      if (buf1[i] != buf2[i]) {
	printf("%08x: %d %d\n", beg + i * sizeof(int), buf1[i], buf2[i]);
      }
    }
    sleep(interval);
    tmp = buf1;
    buf1 = buf2;
    buf2 = tmp;
  }
  return 0;
}

int main(int argc, char **argv) 
{
  if (argc < 3) {
    puts("You must provide 3 arguments, pid, address and size\n");
    return EXIT_FAILURE;
  }
  pid_t pid = atoi(argv[1]);  
  off_t beg = strtol(argv[2], NULL, 16);
  size_t size = strtol(argv[3], NULL, 16);
/*   char *mapspath = mprintf("/proc/%d/maps", pid); */
/*   FILE *mapsfile = fopen(mapspath, "r"); */
/*   if (mapsfile == NULL) { */
/*     perrquit("fopen() maps file"); */
/*   } */
/*   uint beg, end; */
/*   fscanf(mapsfile, "%x-%x ", &beg, &end); */
/*   printf("beg=%x, end=%x\n", beg, end); */
/*   close(mapsfile); */
/*   FILE *memfile = fopen(mprintf("/proc/%d/mem", pid), "rw"); */
/*   fseek(memfile, beg, SEEK_SET); */

  mem_watch(pid, beg, size, 1);

  return EXIT_SUCCESS;
}
