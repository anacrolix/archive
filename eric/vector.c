Vector *Vector_CreateVector (void){
	Vector *v = malloc(Vector);
	v->size = 0;
	return v;
}

void Vector_DestroyVector(Vector *vectorHandle){
	free vectorHandle->elements;
}

unsigned int Vector_GetElementCount (Vector *vectorHandle){
	return vectorHandle->size;
}

unsigned int Vector_AddElement(Vector *vectorHandle, void *elementPtr){
	int newSize = Vector_GetElementCount(vectorHandle) + 1;
	void *newArray[] = malloc(newSize * sizeof(void *));
	
}
