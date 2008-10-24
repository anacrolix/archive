#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/time.h>

#include "threadpool.h"
#include "list.c"


#define DEBUG

/*----------------------------------------------------------------------
  Utility function: "elapsed-time fprintf".  fprintf, but prepends the 
    time difference between the first argument and now.
*/
void etfprintf(struct timeval then, ...) {
  va_list         args;
  struct timeval  now;
  struct timeval  diff;
  FILE           *out;
  char           *fmt;
  
  va_start(args, then);
  out = va_arg(args, FILE *);
  fmt = va_arg(args, char *);
  
  gettimeofday(&now, NULL);
  timersub(&now, &then, &diff);
  fprintf(out, "%03d.%06d:", (int) diff.tv_sec, (int) diff.tv_usec);
  vfprintf(out, fmt, args);
  fflush(NULL);
  va_end(args);
}

typedef enum {
  ALL_RUN, ALL_EXIT
} poolstate_t;

/*----------------------------------------------------------------------
  _threadpool is the internal threadpool structure that is cast to type 
    "threadpool" before it given out to callers.
  All accesses to a _threadpool (both read and write) must be protected 
    by that pool's mutex.  
  Worker threads wait on a "job_posted" signal; when one is received the 
    receiving thread (which has the mutex):
      * checks the pool state. If it is ALL_EXIT the thread decrements 
        the pool's 'live' count, yields the mutex and exits; otherwise 
        continues:
      * while the job queue is not empty:
        * copy the job and arg fields into the thread, 
        * NULL out the pool's job and arg fields
        * signal "job_taken" 
        * yield the mutex and run the job on the arg.
        * grab the mutex
      * when a null job field is found, wait on "job_posted"
  The dispatcher thread dispatches a job as follows:
      * grab the pool's mutex
      * while the job field is not NULL: 
        * signal "job_posted"
        * wait on "job_taken"
      * copy job and args to pool, signal "job_posted", yield the mutex
*/
typedef struct _threadpool_st {
  struct timeval  created;    // When the threadpool was created.
  pthread_t      *array;      // The threads themselves.

  pthread_mutex_t mutex;      // protects all vars declared below.
  pthread_cond_t  job_posted; // dispatcher: "Hey guys, there's a job!"
  pthread_cond_t  job_taken;  // a worker: "Got it!"
  
  poolstate_t     state;      // Threads check this before getting job.
  int             arrsz;      // Number of entries in array.
  int             live;       // Number of live threads in pool (when
                              //   pool is being destroyed, live<=arrsz)

  queueHead      *theQueue;      // queue of work orders
} _threadpool;


/*----------------------------------------------------------------------
  Define the life of a working thread.
*/
void * do_work(void * owning_pool) {
  // Convert pointer to owning pool to proper type.
  _threadpool *pool = (_threadpool *) owning_pool;
  
  // Remember my creation sequence number
  int myid = pool->live;

  // When we get a posted job, we copy it into these local vars.
  dispatch_fn  myjob;
  void        *myarg;  
  dispatch_fn  mycleaner;
  void        *mycleanarg;
#ifdef DEBUG
  etfprintf(pool->created, stderr, 
      " >>> Thread[%d] starting, grabbing mutex.\n", myid);
#endif
  pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS,NULL);
  pthread_cleanup_push(pthread_mutex_unlock, (void *) &pool->mutex);

  // Grab mutex so we can begin waiting for a job
  if (0 != pthread_mutex_lock(&pool->mutex)) 
    {
      perror("\nMutex lock failed!:");
      exit(EXIT_FAILURE);
    }
  
  // Main loop: wait for job posting, do job(s) ... forever
  for( ; ; ) {
    
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " <<< Thread[%d] waiting for signal.\n", myid);
#endif
  
    while(isJobAvailable(pool->theQueue)==0)
      {
	pthread_cond_wait(&pool->job_posted, &pool->mutex);
      }
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " >>> Thread[%d] received signal.\n", myid);
#endif
  
    // We've just woken up and we have the mutex.  Check pool's state
    if (ALL_EXIT == pool->state)
      break;
    
    // while we find work to do
    getWorkOrder(pool->theQueue, &myjob, &myarg, &mycleaner, &mycleanarg);
    pthread_cond_signal(&pool->job_taken);
    
#ifdef DEBUG
    etfprintf(pool->created, stderr,
	      " <<< Thread[%d] yielding mutex, taking job.\n", myid);
#endif
    
    // Yield mutex so other jobs can be posted
    if (0 != pthread_mutex_unlock(&pool->mutex)) 
      {
	perror("\n\nMutex unlock failed!:");
	exit(EXIT_FAILURE);
      }
    
    // Run the job we've taken
    if(mycleaner != NULL)
      {
    pthread_cleanup_push(mycleaner,mycleanarg);
    myjob(myarg);
    pthread_cleanup_pop(1);
      }
    else
      {
	myjob(myarg);
      }
#ifdef DEBUG
    etfprintf(pool->created, stderr,
	      " >>> Thread[%d] job done, grabbing mutex.\n", myid);
#endif
    
    // Grab mutex so we can grab posted job, or (if no job is posted)
    //   begin waiting for next posting.
    if (0 != pthread_mutex_lock(&pool->mutex))
      {
	perror("\n\nMutex lock failed!:");
	exit(EXIT_FAILURE);
      }
  }
  
  // If we get here, we broke from loop because state is ALL_EXIT.
  --pool->live;
  
#ifdef DEBUG
  etfprintf(pool->created, stderr, 
	    " <<< Thread[%d] exiting (signalling 'job_taken').\n", myid);
#endif
  
  // We're not really taking a job ... but this signals the destroyer
  //   that one thread has exited, so it can keep on destroying.
  pthread_cond_signal(&pool->job_taken);
  
  if (0 != pthread_mutex_unlock(&pool->mutex))
    {
      perror("\n\nMutex unlock failed!:");
      exit(EXIT_FAILURE);
    }
  pthread_cleanup_pop(1);
  return NULL;
}  

/*----------------------------------------------------------------------
  Create a thread pool.
*/
threadpool create_threadpool(int num_threads_in_pool) {
  _threadpool *pool;  // pool we create and hand back
  int i;              // work var

  // sanity check the argument
  if ((num_threads_in_pool <= 0) || (num_threads_in_pool > MAXT_IN_POOL))
    return NULL;

  // create the _threadpool struct
  pool = (_threadpool *) malloc(sizeof(_threadpool));
  if (pool == NULL) {
    fprintf(stderr, "\n\nOut of memory creating a new threadpool!\n");
    return NULL;
  }

  // initialize everything but the array and live thread count
  pthread_mutex_init(&(pool->mutex), NULL);
  pthread_cond_init(&(pool->job_posted), NULL);
  pthread_cond_init(&(pool->job_taken), NULL);
  pool->arrsz = num_threads_in_pool;
  pool->state = ALL_RUN;
  pool->theQueue = makeQueue(num_threads_in_pool);
  gettimeofday(&pool->created, NULL);

  // create the array of threads within the pool
  pool->array = 
      (pthread_t *) malloc (pool->arrsz * sizeof(pthread_t));
  if (NULL == pool->array) {
    fprintf(stderr, "\n\nOut of memory allocating thread array!\n");
    free(pool);
    pool = NULL;
    return NULL;
  }

  // bring each thread to life (update counters in loop so threads can
  //   access pool->live to find out their ID#
  for (i = 0; i < pool->arrsz; ++i) {
    if (0 != pthread_create(pool->array + i, NULL, do_work, (void *) pool)) {
      perror("\n\nThread creation failed:");
      exit(EXIT_FAILURE);
    }
    pool->live = i+1;
    pthread_detach(pool->array[i]);  // automatic cleanup when thread exits.
  }
  
#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " <<< Threadpool created with %d threads.\n", num_threads_in_pool);
#endif
  
  return (threadpool) pool;
}


/*----------------------------------------------------------------------
  Dispatch a thread
*/
void dispatch(threadpool from_me, dispatch_fn dispatch_to_here,
	      void *arg) {
  _threadpool *pool = (_threadpool *) from_me;
  int old_cancel;
  if(pool == (_threadpool *) arg)
    {
    }
  else
    {
  pthread_cleanup_push(pthread_mutex_unlock, (void *) &pool->mutex);
#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " >>> Dispatcher: grabbing mutex.\n");
#endif
  
  // Grab the mutex
  if (0 != pthread_mutex_lock(&pool->mutex)) {
    perror("Mutex lock failed (!!):");
    exit(-1);
  }

  while(!canAcceptWork(pool->theQueue))
    {
      pthread_cond_signal(&pool->job_posted);
      pthread_cond_wait(&pool->job_taken,&pool->mutex);
    }
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " <<< Dispatcher: job queue full, %s\n",
        "signaling 'posted', waiting on 'taken'.");
#endif
   
  
  // Finally, there's room to post a job. Do so and signal workers.
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " <<< Dispatcher: posting job, signaling 'posted', yielding mutex\n");
#endif
    addWorkOrder(pool->theQueue,dispatch_to_here,arg,NULL,NULL);

    pthread_cond_signal(&pool->job_posted);
  
    // Yield mutex so a worker can pick up the job
    if (0 != pthread_mutex_unlock(&pool->mutex)) 
      {
	perror("\n\nMutex unlock failed!:");
	exit(EXIT_FAILURE);
      }
    pthread_cleanup_pop(1);
    }
}


void dispatch_with_cleanup(threadpool from_me, dispatch_fn dispatch_to_here,
	      void *arg, dispatch_fn cleaner_func, void * cleaner_arg) {
  _threadpool *pool = (_threadpool *) from_me;
  int old_cancel;
  if(pool == (_threadpool *) arg)
    {
    }
  else
    {
  pthread_cleanup_push(pthread_mutex_unlock, (void *) &pool->mutex);
#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " >>> Dispatcher: grabbing mutex.\n");
#endif
  
  // Grab the mutex
  if (0 != pthread_mutex_lock(&pool->mutex)) {
    perror("Mutex lock failed (!!):");
    exit(-1);
  }

  while(!canAcceptWork(pool->theQueue))
    {
      pthread_cond_signal(&pool->job_posted);
      pthread_cond_wait(&pool->job_taken,&pool->mutex);
    }
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " <<< Dispatcher: job queue full, %s\n",
        "signaling 'posted', waiting on 'taken'.");
#endif
   
  
  // Finally, there's room to post a job. Do so and signal workers.
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " <<< Dispatcher: posting job, signaling 'posted', yielding mutex\n");
#endif
    addWorkOrder(pool->theQueue,dispatch_to_here,arg,cleaner_func,cleaner_arg);

    pthread_cond_signal(&pool->job_posted);
  
    // Yield mutex so a worker can pick up the job
    if (0 != pthread_mutex_unlock(&pool->mutex)) 
      {
	perror("\n\nMutex unlock failed!:");
	exit(EXIT_FAILURE);
      }
    pthread_cleanup_pop(1);
    }
}

/*----------------------------------------------------------------------
  Destroy a thread pool.  If there is a job still waiting for a thread
    to execute it, tough.  We set the ALL_EXIT flag anyways.
*/
void destroy_threadpool(threadpool destroyme) 
{
  _threadpool *pool = (_threadpool *) destroyme;
  int oldtype;

  pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, &oldtype);
  pthread_cleanup_push(pthread_mutex_unlock, (void *) &pool->mutex);  


  // Cause all threads to exit. Because they were detached when created,
  //   the underlying memory for each is automatically reclaimed.
#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " >>> Destroyer: grabbing mutex, setting state to ALL_EXIT. Live = %d\n",
      pool->live);
#endif
  
  // Grab the mutex
  if (0 != pthread_mutex_lock(&pool->mutex)) {
    perror("Mutex lock failed (!!):");
    exit(-1);
  }

  pool->state = ALL_EXIT;
  
  while (pool->live > 0) {
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " <<< Destroyer: signalling 'job_posted', waiting on 'job_taken'.\n");
#endif
    // get workers to check in ...
    pthread_cond_signal(&pool->job_posted);
    // ... and wake up when they check out.
    pthread_cond_wait(&pool->job_taken, &pool->mutex);
#ifdef DEBUG
    etfprintf(pool->created, stderr,
        " >>> Destroyer: received 'job_taken'. Live = %d\n", pool->live);
#endif
  }
  
  // Null-out entries in pool's thread array; free array.
  memset(pool->array, 0, pool->arrsz * sizeof(pthread_t));
  free(pool->array);
  
  // Destroy the mutex and condition variables in the pool.
#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " <<< Destroyer: releasing mutex prior to destroying it.\n");
#endif

  pthread_cleanup_pop(0);  
  if (0 != pthread_mutex_unlock(&pool->mutex)) {
    perror("\n\nMutex unlock failed!:");
    exit(EXIT_FAILURE);
  }
  
#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " --- Destroyer: destroying mutex.\n");
#endif
  
  if (0 != pthread_mutex_destroy(&pool->mutex)) {
    perror("\nMutex destruction failed!:");
    exit(EXIT_FAILURE);
  }

#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " --- Destroyer: destroying conditional variables.\n");
#endif
  
  if (0 != pthread_cond_destroy(&pool->job_posted)) {
    perror("\nCondition Variable 'job_posted' destruction failed!:");
    exit(EXIT_FAILURE);
  }
  
  if (0 != pthread_cond_destroy(&pool->job_taken)) {
    perror("\nCondition Variable 'job_taken' destruction failed!:");
    exit(EXIT_FAILURE);
  }
  
  // Zero out all bytes of the pool
  memset(pool, 0, sizeof(_threadpool));
  
  // Free the pool and null out the pointer to it
  free(pool);
  pool = NULL;
  destroyme = NULL;
}

void destroy_threadpool_immediately(threadpool destroymenow)
{
    _threadpool *pool = (_threadpool *) destroymenow;
    int oldtype,i;

    pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, &oldtype);

    pthread_cleanup_push(pthread_mutex_unlock, (void *) &pool->mutex);
    pthread_mutex_lock(&pool->mutex);

  
    for(i=0;i<pool->arrsz;i++)
    	  {
	    if(0 != pthread_cancel(pool->array[i]))
	      {
		perror("Destruction of thread failed!\n");
	      }
	  }

  #ifdef DEBUG
  etfprintf(pool->created, stderr,
	    " --- Destroyer: destroying mutex.\n");
  #endif


  pthread_cleanup_pop(0);

  if (0 != pthread_mutex_destroy(&pool->mutex)) {
    perror("\nMutex destruction failed!:");
    exit(EXIT_FAILURE);
  }

#ifdef DEBUG
  etfprintf(pool->created, stderr,
      " --- Destroyer: destroying conditional variables.\n");
#endif

 if (0 != pthread_cond_destroy(&pool->job_posted)) {
    perror("\nCondition Variable 'job_posted' destruction failed!:");
    exit(EXIT_FAILURE);
  }
  
  if (0 != pthread_cond_destroy(&pool->job_taken)) {
    perror("\nCondition Variable 'job_taken' destruction failed!:");
    exit(EXIT_FAILURE);
  }


  // Zero out all bytes of the pool
  memset(pool, 0, sizeof(_threadpool));
  
  // Free the pool and null out the pointer to it
  free(pool);
  pool = NULL;
  destroymenow = NULL;
}









