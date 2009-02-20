#include "vector.h"

Vector *Vector_CreateVector (void){
    Vector *v = malloc(sizeof(Vector));
    v->size = 0;
    return v;
}

void Vector_DestroyVector(Vector *vectorHandle){
    free(vectorHandle->elements);
}

unsigned int Vector_GetElementCount (Vector *vectorHandle){
    return vectorHandle->size;
}

unsigned int Vector_AddElement(Vector *vectorHandle, void *elementPtr)
{
    int oldSize = Vector_GetElementCount(vectorHandle);
    int newSize = oldSize + 1;

    void *newArray[];
    newArray = (void **) malloc(newSize * sizeof(void *));

    //transfer all the old shit, to the new array
    int i;
    for(i = 0; i < oldSize; i++)
    {
    newArray[i] = vectorHandle->element[i];
    }
    //now fill the last value, with the new value
    //remember arrays start at zero, so [oldSize] is the newest
    newArray[oldSize] = elementPtr;

    //clear the old array
    free(vectorHandle->elements);

    //replace it
    vectorHandle->elements = newArray;
    
}

unsigned int Vector_RemoveElement (Vector *vectorHandle, unsigned int elementPosition){
    int oldSize = Vector_GetElementCount(vectorHandle);
    int newSize = oldSize - 1;

    void *newArray[] = malloc(newSize * sizeof(void *));

    //transfer all the old shit, to the new array
    int i;
    for(i = 0; i < newSize; i++)
    {
        int j = (i < elementPosition) ? i : (i+1);

        newArray[i] = vectorHandle->element[j];
    }
    //now fill the last value, with the new value
    //remember arrays start at zero, so [oldSize] is the newest
    newArray[oldSize] = elementPtr;

    //clear the old array
    free(vectorHandle->elements);

    //replace it
    vectorHandle->elements = newArray;
}

void *Vector_GetElement(Vector *vectorHandle, unsigned int elementPosition)
{
    return vectorHandle->elements[elementPosition];
}
