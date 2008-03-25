#include <stdlib.h>
#include "cube.h"

const enum Face_e
EDGE_COMPASS[FACES_PER_CUBE][EDGES_PER_FACE] = {
	{FACE_U, FACE_R, FACE_D, FACE_L}, //F
	{FACE_B, FACE_R, FACE_F, FACE_L}, //U
	{FACE_U, FACE_B, FACE_D, FACE_F}, //R
	{FACE_F, FACE_R, FACE_B, FACE_L}, //D
	{FACE_U, FACE_L, FACE_D, FACE_R}, //B
	{FACE_U, FACE_F, FACE_D, FACE_B}  //L
};

const enum Tile_e
EDGE_MAPPING[FACES_PER_CUBE][EDGES_PER_FACE][TILES_PER_EDGE] =
{
	{{TILE_BL, TILE_B, TILE_BR},
	{TILE_TL, TILE_L, TILE_BL},
	{TILE_TR, TILE_T, TILE_TL},
	{TILE_BR, TILE_R, TILE_TR}},

	{{TILE_TR, TILE_T, TILE_TL},
	{TILE_TR, TILE_T, TILE_TL},
	{TILE_TR, TILE_T, TILE_TL},
	{TILE_TR, TILE_T, TILE_TL}},

	{{TILE_BR, TILE_R, TILE_TR},
	{TILE_TL, TILE_L, TILE_BL},
	{TILE_BR, TILE_R, TILE_TR},
	{TILE_BR, TILE_R, TILE_TR}},

	{{TILE_BL, TILE_B, TILE_BR},
	{TILE_BL, TILE_B, TILE_BR},
	{TILE_BL, TILE_B, TILE_BR},
	{TILE_BL, TILE_B, TILE_BR}},

	{{TILE_TR, TILE_T, TILE_TL},
	{TILE_TL, TILE_L, TILE_BL},
	{TILE_BL, TILE_B, TILE_BR},
	{TILE_BR, TILE_R, TILE_TR}},

	{{TILE_TL, TILE_L, TILE_BL},
	{TILE_TL, TILE_L, TILE_BL},
	{TILE_TL, TILE_L, TILE_BL},
	{TILE_BR, TILE_R, TILE_TR}}
};



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
