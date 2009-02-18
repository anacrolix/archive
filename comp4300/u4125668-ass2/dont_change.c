#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <assert.h>
#include "headers.h"

void measure_time(int iparm, char* label){
   static struct timeval tp1, tp2;
   static int icheck = 0;
   long int mytime;
   if (iparm == 0){
     assert(icheck == 0);
     gettimeofday(&tp1, NULL);
     icheck = 1;
   } else {
     assert(icheck == 1);
     gettimeofday(&tp2, NULL);
     mytime = (tp2.tv_sec-tp1.tv_sec)*1000000+(tp2.tv_usec-tp1.tv_usec);
     printf("%20s Time %12ld\n",label,mytime);
     icheck = 0;
   }
}

void prtvec(int x[], int n, char* title)
{
    int ichk,ilim,i;
    if (n < MAX_PRINT){
      printf("prtvec: %-60s\n",title);
      for (ichk = 0; ichk < n; ichk+=8){
	ilim = (ichk+8 < n) ? ichk+8 : n;
	for (i = ichk; i < ilim; i++)printf("%10d",x[i]);
	printf("\n");
      }
    }
}
void init_data( int* data, int N, int MxInt)
{
  int i;
  long int seed;
  struct timeval tp1;

  /* Generate N random integers */
  gettimeofday(&tp1, NULL);
  seed = tp1.tv_usec;
  srand48(seed);
  /* generate random numbers from 0-(MxInt-1) */
    for (i = 0; i < N; i++)data[i] = lrand48()%MxInt;
}

void radixsort(int *val, int N, int MxInt)
{
  int i,j,ilow,ihigh,nlevel;
  int *tmp;

  /* If it weren't so late at night I could probably get rid of tmp!! */
  tmp = (int*) malloc( N*sizeof(int));

  for (i=1, nlevel=0; i<MxInt && nlevel<32; i*=2, nlevel++){
    ilow=0;
    ihigh=0;
    for (j=0;j<N;j++){
      if (((val[j] >> nlevel) & 1) == 0){
	val[ilow]=val[j];
	ilow++;
      } else {
	tmp[ihigh]=val[j];
	ihigh++;
      }
    }
    for (j=0;j<ihigh;j++)val[ilow+j]=tmp[j];
  }
  free(tmp);
}
void check_results(int* check_data, int* data, int N)
{
  int i, ierr;
  ierr=0;
  for (i = 0; i < N && ierr < 10; i++){
    if (check_data[i] != data[i]){
      printf("ERROR %d %12d should be %12d\n",i,data[i],check_data[i]);
      ierr++;
    }
  }
  assert(ierr==0);
  return;
}
