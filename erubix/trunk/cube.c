#include <stdlib.h>
#include "cube.h"

void Cube_Init(Cube *cube)
{
	cube->parent = NULL;
	cube->lastMove = -1;
	cube->depth = -1;
	for (int f = 0; f < FACES_PER_CUBE; f++) {
		for (int t = 0; t < TILES_PER_FACE; t++) {
			cube->face[f].tile[t] = -1;
		}
	}
	for (int i = 0; i < UNIQUE_MOVES; i++) {
		cube->nextMove[i] = NULL;
	}
}
