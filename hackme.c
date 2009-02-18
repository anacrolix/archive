#include <stdio.h>
#include <stdlib.h>
typedef unsigned int uint;

uint static_var = 0;

int main () {
  uint *heap_var = malloc(sizeof(uint));
  *heap_var = 1000;
  uint stack_var = 2000;
  while (1) {
    printf("static variable=%d\n", static_var++);
    printf("heap variable=%d\n", (*heap_var)++);
    printf("stack variable=%d\n", stack_var++);
    sleep(5);
  }
}
