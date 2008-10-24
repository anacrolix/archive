#include <stdlib.h>
#define MAX_QUEUE_MEMORY_SIZE 65536


//typedef struct queueNode queueNode;

typedef struct queueNode
{
  dispatch_fn func_to_dispatch;
  void * func_arg;
  dispatch_fn cleanup_func;
  void * cleanup_arg;
  struct queueNode * next;
  struct queueNode * prev;
} queueNode;

typedef struct queueHead
{
	struct queueNode * head;
	struct queueNode * tail;
	struct queueNode * freeHead;
	struct queueNode * freeTail;
	int capacity;
	int max_capacity;
}queueHead;


struct queueHead * makeQueue(int initial_cap)
{
	queueHead * theQueue = (queueHead *) malloc (sizeof(queueHead));
	int max_cap = MAX_QUEUE_MEMORY_SIZE / (sizeof(queueNode)),i;
	queueNode * temp;
	if(theQueue == NULL)
	{
		perror("Out of memory on malloc\n");
		exit(2);
	}
	if(initial_cap > max_cap)
	{
		initial_cap = max_cap;
	}
	if(initial_cap == 0)
	{
		perror("Attempting to create a queue that holds no work orders\n");
		exit(2);
	}
	theQueue->capacity =initial_cap;
	theQueue->max_capacity = max_cap;
	theQueue->head = NULL;
	theQueue->tail = NULL;
	theQueue->freeHead = (queueNode *) malloc (sizeof(queueNode));
	if(theQueue->freeHead == NULL)
	{
		perror("Out of memory on malloc\n");
		exit(2);
	}
	theQueue->freeTail = theQueue->freeHead;

	//populate the free queue
	for(i = 1;i<=initial_cap;i++)
	{
		temp = (queueNode *) malloc (sizeof(queueNode));
		if(temp == NULL)
		{
			perror("Out of memory on malloc\n");
			exit(2);
		}
		temp->next = theQueue->freeHead;
		temp->prev = NULL;
		theQueue->freeHead->prev = temp;
		theQueue->freeHead=temp;
	}
	return theQueue;
}


void addWorkOrder(queueHead * theQueue, dispatch_fn func1, void * arg1, dispatch_fn func2, void * arg2)
{
	queueNode * temp;
		
	if(theQueue->freeTail == NULL)
	{
	    temp = (queueNode *) malloc (sizeof(queueNode));
		if(temp == NULL)
		{
			perror("Out of memory on malloc\n");
			exit(2);
		}
		temp->next = NULL;
		temp->prev = NULL;
		theQueue->freeHead = temp;
		theQueue->freeTail = temp;
		theQueue->capacity++;
	}
	
	temp = theQueue->freeTail;
	if(theQueue->freeTail->prev == NULL)
	{
		theQueue->freeTail = NULL;
		theQueue->freeHead = NULL;
	}
	else
	{
		theQueue->freeTail->prev->next= NULL;
		theQueue->freeTail = theQueue->freeTail->prev;
		theQueue->freeTail->next=NULL;
	}
	
	temp->func_to_dispatch = func1;
	temp->func_arg = arg1;
	temp->cleanup_func = func2;
	temp->cleanup_arg = arg2;

	temp->prev=NULL;
	if(theQueue->head == NULL)
	{
		theQueue->tail = temp;
		theQueue->head = temp;
	}
	else
	{
		temp->next=theQueue->head;
		theQueue->head->prev = temp;
		theQueue->head=temp;
	}
}


void getWorkOrder(queueHead * theQueue, dispatch_fn * func1, void ** arg1, dispatch_fn * func2, void ** arg2)
{
	queueNode * temp;
		
	temp = theQueue->tail;
	if(temp == NULL)
	{
		perror("Attempting to getWorkOrder from an empty queue.\n");
		exit(2);
	}

	if(theQueue->tail->prev == NULL)
	{
		theQueue->tail = NULL;
		theQueue->head = NULL;
	}
	else
	{
		theQueue->tail->prev->next = NULL;
		theQueue->tail = theQueue->tail->prev;
		theQueue->tail->next=NULL;
	}
	
	*func1 = temp->func_to_dispatch;
	*arg1  = temp->func_arg;
	*func2 = temp->cleanup_func;
	*arg2  = temp->cleanup_arg;

	temp->next=NULL;
	if(theQueue->freeHead == NULL)
	{
		theQueue->freeTail = temp;
		theQueue->freeHead = temp;
		temp->prev=NULL;
		
	}
	else
	{
		temp->next=theQueue->freeHead;
		theQueue->freeHead->prev = temp;
		theQueue->freeHead=temp;
	}
}

int canAcceptWork(struct queueHead * theQueue)
{
	return(theQueue->freeTail != NULL
	       || theQueue->capacity <= theQueue->max_capacity);
}

int isJobAvailable(struct queueHead * theQueue)
{
  return(theQueue->tail != NULL);
}





