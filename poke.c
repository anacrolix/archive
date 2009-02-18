#include <sys/ptrace.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>

int main() {
  ptrace(PTRACE_ATTACH, 5708, NULL, NULL);
  waitpid(5708, NULL, 0);
  int mem = open("/proc/5708/mem", O_RDWR);
  lseek(mem, 0x804B008, SEEK_SET);
  long l = 5000;
  if (write(mem, &l, sizeof(l)) == -1) {
    perror("write()");
    //return 1;
  }
  if (ptrace(PTRACE_POKEDATA, 5708, 0x804B008, &l) == -1) {
    perror("ptrace()");
    return 1;
  }
  ptrace(PTRACE_DETACH, 5708, NULL, NULL);
}
