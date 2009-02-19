int main () {
  while (1) {
    printf("start while loop");
    if (1) {
      continue;
    } else {
      printf("breaking");
      break;
    }
  }
  printf("end main");
  return 0;
}
