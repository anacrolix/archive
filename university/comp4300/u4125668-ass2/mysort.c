#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <assert.h>
#include <pthread.h>
#include "headers.h"
#include "stack.h"

//#define DEBUG

static void recur_qsort(int*, int, int);
static int partition(int*, int, int);
static void insertsort(int*, int);

static void qsort_1(int*, int);

static void *qsort_2(void*);

static void qsort_3 (int*, int, const int);
static void *qsort_3_thread (void*);

static void qsort_4 (int*, int, const int);
static void *qsort_4_thread (void*);

struct recur_pthread_qsort_args {
  int *data;
  int left;
  int right;
  int *numBusyThreads;
  int maxThreads;
};

int main (int argc, char **argv) {
  int N,MxInt,i,Nthread;
  int *data, *check_data, *unsorted_data;

  printf("\n COMP4300 Ass2 Sorting Program\n");

  printf(" Input Total Number of Data Items\n");
  printf(" Maximum Integer Value\n");
  printf(" and Number of Threads to Create\n");
  scanf("%d%d%d",&N,&MxInt,&Nthread);
  assert(MxInt<MAX_INTS);
  assert(N>0 && N<MAX_INTS);
  assert(Nthread > 0 && Nthread < MAX_THRDS);
  printf("\n-------------------------------------\n");
  printf(" Total Number of Data Items %-12d\n",N);
  printf(" Maximum Integer Value      %-12d\n",MxInt);
  printf(" Number of Threads to Use   %-12d\n",Nthread);
  printf("-------------------------------------\n\n");

  /* Allocate data array and generate random numbers */

  unsorted_data = (int *) malloc (N * sizeof(int));
  data         = (int*) malloc( N*sizeof(int) );
  check_data   = (int*) malloc( N*sizeof(int) );
  init_data (unsorted_data, N, MxInt);
  prtvec(unsorted_data,N,"Unsorted Data");

  /* Take copy and sort using radix sort, then use to verify */
  for (i = 0; i < N; i++) check_data[i] = unsorted_data[i];

  /* RADIX SORT */
  measure_time(START_TIME, NULL);
  radixsort(check_data, N, MxInt);
  measure_time(STOP_TIME, "RadixSort");
  
  for (i = 0; i < N; i++) data[i] = unsorted_data[i];

  // RECURSIVE SORT
  measure_time(START_TIME, NULL);
  recur_qsort(data, 0, N-1);
  measure_time(STOP_TIME, "Recursive QuickSort");

  check_results(check_data, data, N);
  for (i = 0; i < N; i++) data[i] = unsorted_data[i];

  // ROUTINE 1 - ITERATIVE SORT
  measure_time(START_TIME, NULL);
  qsort_1(data, N);
  measure_time(STOP_TIME, "Routine 1");
  
  check_results(check_data, data, N);
  for (i = 0; i < N; i++) data[i] = unsorted_data[i];

  // ROUTINE 2 - RECURSIVE PTHREAD QUICKSORT
  measure_time(START_TIME, NULL);
  int numBusyThreads = 1;
  struct recur_pthread_qsort_args args = {
    data, 0, N-1, &numBusyThreads, Nthread};
  qsort_2 (&args);
  measure_time(STOP_TIME, "Routine 2");
    
  check_results(check_data, data, N);
  for (i = 0; i < N; i++) data[i] = unsorted_data[i];

  // ROUTINE 3 - ITERATIVE BUSY WAITING PTHREAD QUICKSORT
  measure_time (START_TIME, NULL);
  qsort_3 (data, N, Nthread);
  measure_time (STOP_TIME, "Routine 3");

  check_results(check_data, data, N);
  for (i = 0; i < N; i++) data[i] = unsorted_data[i];

  // ROUTINE 4 - ITERATIVE CV PTHREAD QUICKSORT
  measure_time (START_TIME, NULL);
  qsort_4 (data, N, Nthread);
  measure_time (STOP_TIME, "Routine 4");

  // PRINT "SORTED" DATA
  prtvec(data,N,"Sorted Data");

  /* Sequential check that the results are correct */
  check_results(check_data, data, N);
  printf("Execution completed successfully\n");
  return 0;
}

struct qsort_3_args {
  int *data;
  stackT *work;
  int *busy;
};

struct qsort_4_thread_args {
  int *data;
  stackT *work;
  int *busy;
};

//#define DEBUG

/*
void *qsort_4_thread (void *threadarg) {
  //global busy thread count mutex and cv
  static pthread_mutex_t mutex_busy = PTHREAD_MUTEX_INITIALIZER; //*args->busy
  static pthread_mutex_t mutex_work = PTHREAD_MUTEX_INITIALIZER; //*args->work
  static pthread_mutex_t mutex_cv_work = PTHREAD_MUTEX_INITIALIZER; //cv_work
  static pthread_cond_t cv_work = PTHREAD_COND_INITIALIZER; //waiting for work
  //deference thread argument struct
  const struct qsort_4_thread_args *args = threadarg;
  //working vars
  int left = 0, right = 0, idle = 1, pivot;
  stackElementT element;

  while (1) {
    if (left >= right) { //if not working
#ifdef DEBUG
      printf("No work left\n");
#endif
      pthread_mutex_lock (&mutex_work);
      if (!StackIsEmpty (args->work)) { //see if there is work
	element = StackPop (args->work); //take the work
	if (idle) {
	  pthread_mutex_lock (&mutex_busy);
	  (*args->busy)++;
	  pthread_mutex_unlock (&mutex_busy);
	  idle = 0;
	}
	pthread_mutex_unlock (&mutex_work);
	//pthread_mutex_unlock (&mutex_work);
	left = element.left;
	right = element.right;
	printf("Got work [%d,%d]\n", left, right);
	continue;
      } else if (!idle) {
	pthread_mutex_unlock (&mutex_work);
	idle = 1;
	pthread_mutex_lock (&mutex_busy);
	(*args->busy)--;
	pthread_mutex_unlock (&mutex_busy);
      }	  
      pthread_mutex_lock (&mutex_busy);
      if (*args->busy == 0) {
	pthread_mutex_unlock (&mutex_busy);
	pthread_cond_broadcast (&cv_work);
	return (void *) 0;
      } else {
	pthread_mutex_unlock (&mutex_busy);
#ifdef DEBUG
	printf("Waiting for work\n");
#endif
	pthread_mutex_lock (&mutex_cv_work);
	pthread_cond_wait (&cv_work, &mutex_cv_work);
	pthread_mutex_unlock (&mutex_cv_work);
#ifdef DEBUG
	printf("Signalled work\n");
#endif
      }
    } else {
      //pthread_mutex_unlock (&mutex_work);
#ifdef DEBUG
      printf("%u - %u < %u\n", right, left, SWITCH_THRESH);
#endif
      if (right - left < SWITCH_THRESH) {
#ifdef DEBUG
	printf("Insertion Sort: [%d, %d]\n", left, right);
#endif
	insertsort (&args->data[left], right - left + 1);
	left = right;
      } else {
	pivot = partition (args->data, left, right);
	element.left = pivot + 1;
	element.right = right;
	pthread_mutex_lock (&mutex_work);
	StackPush (args->work, element);
	pthread_mutex_unlock (&mutex_work);
#ifdef DEBUG
	printf("Signalling new work\n");
#endif 
	pthread_cond_signal (&cv_work);
	right = pivot;
      }
    }    
  }
}
*/


void *qsort_4_thread (void *threadarg) {
  //global busy thread count mutex and cv
  static pthread_mutex_t mutex_busy = PTHREAD_MUTEX_INITIALIZER;
  static pthread_cond_t cv_work = PTHREAD_COND_INITIALIZER;
  //deference thread argument struct
  struct qsort_4_thread_args *args = threadarg;
  //working vars
  int left, right, idle = 1, pivot;
  stackElementT element;

  while (1) {
    while (idle) {
      //try to get work
      pthread_mutex_lock (&mutex_busy);
      if (!StackIsEmpty (args->work)) {
	element = StackPop (args->work);
	(*args->busy)++;
	pthread_mutex_unlock (&mutex_busy);
	left = element.left;
	right = element.right;
	idle = 0;
	continue;
      }
      //if there's no work and nobody is busy signal and quit
      if (*args->busy == 0) {
	pthread_cond_broadcast (&cv_work);
	pthread_mutex_unlock (&mutex_busy);
	return (void *) 0;
      }
      //wait for signal of more work
      pthread_cond_wait (&cv_work, &mutex_busy);
      pthread_mutex_unlock (&mutex_busy);
    }
    while (!idle) {
      //if nothing to do, set idle and decrement busy
      if (left >= right) {
	idle = 1;
	pthread_mutex_lock (&mutex_busy);
	(*args->busy)--;
	pthread_mutex_unlock (&mutex_busy);
	continue;
      }
      //if problem small enough, insert sort
      if (right - left < SWITCH_THRESH && left < right) {
	insertsort (&args->data[left], right - left + 1);
	left = right;
      } else {
	//else partition, push and signal
	pivot = partition (args->data, left, right);
	element.left = pivot + 1;
	element.right = right;
	right = pivot;
	pthread_mutex_lock (&mutex_busy);
	StackPush (args->work, element);
	pthread_cond_broadcast (&cv_work);
	pthread_mutex_unlock (&mutex_busy);
      }
    }
  }
}

void qsort_4 (int *arr, int size, const int numThreads) {
  //temp vals
  int i;
  //initialize stack
  stackT work;
  stackElementT element = {0, size-1};
  StackInit (&work, size);
  StackPush (&work, element);
  //initialize all threads
  pthread_t *threads;
  threads = malloc (numThreads * sizeof(pthread_t));
  int busyThreads = 0;
  struct qsort_4_thread_args shared_arg = {arr, &work, &busyThreads};
  for (i = 0; i < numThreads; i++) {
#ifdef DEBUG
    printf("Creating thread %d\n", i+1);
#endif
    if (pthread_create(&threads[i], NULL, qsort_4_thread, &shared_arg)) {
      perror("pthread_create");
      exit(-1);
    }
  }
#ifdef DEBUG
  printf("Created all threads\n");
#endif
  //destroy all threads
  int status;
  for (i = 0; i < numThreads; i++) {
#ifdef DEBUG
    printf("Joining thread %d\n", i+1);
#endif
    pthread_join(threads[i], (void **)&status);
  }
#ifdef DEBUG
  printf("Joined all threads\n");
#endif
  free (threads);
  //destroy stack
  StackDestroy (&work);
  return;
}

#undef DEBUG

void *qsort_3_thread (void *threadarg) {
  //global busy thread count mutex
  static pthread_mutex_t mutex_busy = PTHREAD_MUTEX_INITIALIZER;
  //deference thread argument struct
  struct qsort_3_args *args = threadarg;
  //working vars
  int left = 0, right = 0, idle = 1, pivot;
  stackElementT element;
  while (1) {
    if (right - left < SWITCH_THRESH && left < right) {
      //insertsort
#ifdef DEBUG
      printf("Performing insertsort on [%d,%d]\n", left, right);
#endif
      insertsort(&args->data[left], right - left + 1);
      left = right;
    }
    while (left >= right) {
      pthread_mutex_lock (&mutex_busy);
      if (!StackIsEmpty(args->work)) {
	if (idle) (*args->busy)++;
	idle = 0;
	element = StackPop (args->work);
	left = element.left;
	right = element.right;
#ifdef DEBUG
	printf("Thread accepted range [%d,%d]\nBusy threads: %d\n", left, right, *args->busy);
#endif
      } else {
	if (!idle) (*args->busy)--;
	idle = 1;
#ifdef DEBUG
	printf("Busy threads: %d\n", *args->busy);
#endif
      }
      pthread_mutex_unlock (&mutex_busy);
      if (right - left < SWITCH_THRESH && !idle) {
#ifdef DEBUG
	printf("Performing insertsort on [%d,%d]\n", left, right);
#endif
	insertsort(&args->data[left], right - left + 1);
	left = right;
      }
      if (*args->busy == 0) return (void *) 0;
    }
    //partition
    pivot = partition (args->data, left, right);
#ifdef DEBUG
    printf("Partitioned [%d,%d] found pivot %d\n", left, right, pivot);
#endif
    //push area to left
    element.left = left;
    element.right = pivot;
    pthread_mutex_lock (&mutex_busy);
#ifdef DEBUG
    printf("Pushing range [%d,%d]\n", element.left, element.right);
#endif
    StackPush (args->work, element);
    pthread_mutex_unlock (&mutex_busy);
    //process area to right
    left = pivot + 1;
  }
}

void qsort_3 (int *arr, int size, const int numThreads) {
  //temp vals
  int i;
  //initialize stack
  stackT work;
  stackElementT element = {0, size-1};
  StackInit (&work, 2*(size/SWITCH_THRESH+1));
  StackPush (&work, element);
  //initialize all threads
  pthread_t *threads;
  threads = malloc (numThreads * sizeof(pthread_t));
  /*
  if (posix_memalign((void **)&threads, sizeof(pthread_t), MAX_THRDS*sizeof(pthread_t))) {
    perror("posix_memalign");
    exit(-1);
  }
  */
  int busyThreads = 0;
  struct qsort_3_args shared_arg = {arr, &work, &busyThreads};
  for (i = 0; i < numThreads; i++) {
#ifdef DEBUG
    printf("Creating thread %d\n", i+1);
#endif
    if (pthread_create(&threads[i], NULL, qsort_3_thread, &shared_arg)) {
      perror("pthread_create");
      exit(-1);
    }
  }
#ifdef DEBUG
  printf("Created all threads\n");
#endif
  //destroy all threads
  int status;
  for (i=0; i<numThreads; i++) {
#ifdef DEBUG
    printf("Joining thread %d\n", i+1);
#endif
    pthread_join(threads[i], (void **)&status);
  }
#ifdef DEBUG
  printf("Joined all threads\n");
#endif
  free(threads);
  //destroy stack
  StackDestroy (&work);
  return;
}

void *qsort_2 (void *threadarg) {
  //busy thread count mutex
  static pthread_mutex_t mutex_numBusyThreads = PTHREAD_MUTEX_INITIALIZER;  
  //pivot index after partitioning
  int pivot;
  //thread arguments
  struct recur_pthread_qsort_args *args = threadarg, leftargs, rightargs;
  memcpy (&leftargs, args, sizeof(leftargs));
  memcpy (&rightargs, args, sizeof(rightargs));
  //child thread ids
  pthread_t threadid[2];
  //child return stati
  int status;
  //temp vals
  int i;

  if (args->right - args->left < SWITCH_THRESH) {
    insertsort(&args->data[args->left], args->right - args->left + 1);
  } else if (args->left < args->right) {
    pivot = partition (args->data, args->left, args->right);
#ifdef DEBUG
    printf("pivot is at index %d\n", pivot);
#endif
    leftargs.right = pivot;
    rightargs.left = pivot + 1;
    pthread_mutex_lock(&mutex_numBusyThreads);
    if (*(args->numBusyThreads) >= args->maxThreads) {
      pthread_mutex_unlock(&mutex_numBusyThreads);
      //quicksort without spawning
      qsort_2(&leftargs);
      qsort_2(&rightargs);
    } else {
      //increment busy thread count
      *(args->numBusyThreads) += 2;
#ifdef DEBUG      
      printf("+2 busy thread count: %d\n", *(args->numBusyThreads));
#endif
      pthread_mutex_unlock(&mutex_numBusyThreads);
      //spawn new threads
      if (pthread_create(&threadid[0], NULL, qsort_2, &leftargs)) {
	perror("pthread_create (left side)");
	exit(-1);
      } 
      if (pthread_create(&threadid[1], NULL, qsort_2, &rightargs)) {
	perror("pthread_create (right side)");
	exit(-1);
      }
      for (i = 0; i < 2; i++) {
	pthread_join (threadid[i], (void **)&status);
	pthread_mutex_lock(&mutex_numBusyThreads);
	(*args->numBusyThreads)--;
#ifdef DEBUG
	printf("-1 busy thread count %d\n", *(args->numBusyThreads));
#endif
	pthread_mutex_unlock(&mutex_numBusyThreads);
      }
    }
  }
  return 0;
}

void qsort_1 (int *arr, int size) {
  stackT stack;
  stackElementT element, e;
  int k;
  StackInit (&stack, size);
  element.left = 0;
  element.right = size - 1;
  StackPush(&stack, element);
  while (!StackIsEmpty (&stack)) {
    element = StackPop (&stack);
    while (element.left < element.right) {
      if (element.right - element.left < SWITCH_THRESH) {
	insertsort(&arr[element.left], element.right - element.left + 1);
	element.left = element.right;
      } else {
	k = partition(arr, element.left, element.right);
	e.left = element.left;
	e.right = k;
	StackPush(&stack, e);
	element.left = k+1;
      }
    }
  }
  StackDestroy (&stack);
  return;
}

void recur_qsort(int *arr, int i, int j)
{
  int k;

  if (j-i < SWITCH_THRESH){
    insertsort(&arr[i], j-i+1);
  } else if (i<j) {
    k = partition(arr, i, j);
    recur_qsort(arr, i, k);
    recur_qsort(arr, k+1, j);
  }
}

inline int partition(int *arr, int left, int right)
{
  int pivot, temp;

  pivot = arr[(left+right)/2];
  left--;
  right++;
  while (1) {
    do right--; while (arr[right] > pivot);
    do left++; while (arr[left] < pivot);
    if (left < right) {
      temp = arr[left];
      arr[left] = arr[right];
      arr[right] = temp;
    } else
      return right;
  }
}

inline void insertsort(int *a, int N) {
  int i, j, t;

  for (i = 1; i < N; i++) {
    t = a[i];
    j = i;
    while(j >= 1 && t < a[j-1]) {
      a[j] = a[j-1];
      j--;
    }
    a[j] = t;
  }
}

