//heada

struct Vector_st {
	unsigned int size;
	void *elements[];
};

typedef struct Vector_st Vector;

Vector * Vector_CreateVector (void);
void Vector_DestroyVector(Vector *vectorHandle);
unsigned int Vector_GetElementCount (Vector *vectorHandle);
unsigned int Vector_AddElement(Vector *vectorHandle, void * elementPtr);
unsigned int Vector_RemoveElement (Vector *vectorHandle, unsigned int elementPosition);
Vector * Vector_GetElement(Vector *vectorHandle, unsigned int elementPosition);
