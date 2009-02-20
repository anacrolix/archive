/*
reverse.c
Takes a stream from the input,
char by char, then outputs the
reverse.  Runs into trouble if the
stream size exceeds virtual memory size.

By David Edquist.
Date: 2008-08-20.
*/

#include <stdlib.h>
#include <stdio.h>

typedef struct stack_s *stack;
typedef struct snode_s *snode;

typedef struct stack_s {
	char value;
	snode top;
}stack_t;

typedef struct snode_s {
	snode next;
	char data;
}snode_t;

void insert_stack(stack, char);
void dump_stack(stack);


int main(int argc, char** argv)
{
	stack s;
	int c;
	if(!(s = malloc(sizeof(*s)))) {
		fprintf(stderr, "Error: malloc failed in stack_init\n");
		exit(EXIT_FAILURE);
	}
	while ((c=getchar()) != EOF) {
		insert_stack(s, c);
	}
	dump_stack(s);
	free(s);
	s = NULL;
	return EXIT_SUCCESS;
}

void insert_stack(stack s, char c)
{
	snode temp;
	if (s->top == NULL) {	/*stack is empty!*/
		if(!(s->top = malloc(sizeof(*s->top)))) {
			fprintf(stderr, "Error: malloc failed in snode_init\n");
			exit(EXIT_FAILURE);
		}
		s->top->data = c;
		s->top->next = NULL;
	} else {				/*stack isn't empty*/
		temp = s->top;
		if(!(s->top = malloc(sizeof(*s->top)))) {
			fprintf(stderr, "Error: malloc failed in snode_init\n");
			exit(EXIT_FAILURE);
		}
		s->top->data = c;
		s->top->next = temp;
	}
}
void dump_stack(stack s)
{
	snode temp;
	while(s->top != NULL) {
		putchar(s->top->data);
		temp = s->top->next;
		free(s->top);
		s->top = temp;
	}
}
