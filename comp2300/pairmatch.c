/* ---------------------------------------------------------------------

             Name: Matthew Joiner
   Student Number: 4125668
           Course: COMP2300
Assignment Number: 2
Name of this file: pairmatch.c
        Lab Group: 2


I declare that the material I am submitting in this file is entirely
my own work.  I have not collaborated with anyone to produce it, nor
have I copied it, in part or in full, from work produced by someone else.

   --------------------------------------------------------------------- */

#include <stdio.h>
   
#define SEQMAX 10   

void readSeq(char *s, int len) {
  int i = 0;
  char c = getchar();
  while (c != '\0' && c != '\n') {
    if (i < len) s[i] = c;
    i++;
    c = getchar();
  }
  if (i < len) s[i] = '\0';
  return;
}

int matchPairs(char *s1, char *s2, int len) {
  int i, j, matches = 0, usedPair[len];
  //clear usePair
  for (i=0;i<len;i++) usedPair[i]=0;
  for (i=0; i+1 < len && s1[i+1] != '\0'; i++) {
    for (j=0; j+1 < len && s2[j+1] != '\0'; j++) {
      //printf("\n%.2s,%.2s", &s1[i], &s2[j]);
      if (usedPair[j] == 0 && s1[i] == s2[j] && s1[i+1] == s2[j+1]) {
        matches++;
        //printf(" MATCH");
        usedPair[j] = 1;
        break;
      }
    }
  }
  //printf("\n");
  /*printf("Matching pairs: ");
  for (i=0;i+1<len && s2[i+1] != '\0';i++) if (usedPair[i]) printf("%.2s, ",&s2[i]);
  printf("\n");*/
  return matches;
}

int main(void) {
  char firstLine[SEQMAX], secondLine[SEQMAX];
  readSeq(firstLine, SEQMAX);
  readSeq(secondLine, SEQMAX);
  printf("%d\n", matchPairs(firstLine, secondLine, SEQMAX));
  return 0;
}
