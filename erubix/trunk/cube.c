#include <stdlib.h>
#include <assert.h>
#include <errno.h>
#include <error.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include "eruutil/erudebug.h"
#include "cube.h"

const enum Face_e
EDGE_COMPASS[FACES_PER_CUBE][EDGES_PER_FACE] =
{
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

const char *Move_str[] = {"F", "F'", "U", "U'", "R", "R'", "D", "D'", "B", "B'", "L", "L'"};

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

Cube *Cube_Alloc()
{
	Cube *cube = malloc(sizeof(Cube));
	if (cube == NULL) fatal(errno, "malloc()");
	return cube;
}

Cube *Cube_New()
{
	Cube *cube = Cube_Alloc();
	Cube_Init(cube);
	return cube;
}

void Cube_Kill(Cube *cube)
{
	// unlink from parent
	if (cube->parent != NULL) {
		assert(cube->parent->nextMove[cube->lastMove] == cube);
		cube->parent->nextMove[cube->lastMove] = NULL;
	}
	// destroy children
	for (int i = 0; i < UNIQUE_MOVES; i++) {
		if (cube->nextMove[i] != NULL) {
			Cube_Kill(cube->nextMove[i]);
		}
		assert(cube->nextMove[i] == NULL);
	}
	// destroy this cube
	free(cube);
}

bool Cube_ValidateTiles(Cube *cube)
{
	// count tiles of each color
	int colorCount[FACES_PER_CUBE] = {0};
#ifndef NDEBUG
	// check array initialized to 0
	for (int i = 0; i < FACES_PER_CUBE; i++) {
		if (colorCount[i] != 0) fatal(0, __func__);
	}
#endif
	// add up the tiles of each color
	for (int face = 0; face < FACES_PER_CUBE; face++) {
		for (int tile = 0; tile < TILES_PER_FACE; tile++) {
			int color = cube->face[face].tile[tile];
			assert(color >= 0 && color < FACES_PER_CUBE);
			colorCount[color]++;
		}
	}
	// check the tile color count is correct
	for (int color = 0; color < FACES_PER_CUBE; color++) {
		if (colorCount[color] != TILES_PER_FACE) {
			return false;
		}
	}
	return true;
}

bool Cube_LoadTiles(Cube *cube, const char *tiles, const char *key)
{
	if (strlen(tiles) != FACES_PER_CUBE * TILES_PER_FACE) {
#ifndef NDEBUG
		if (strlen(tiles) > FACES_PER_CUBE * TILES_PER_FACE) {
			debugln("tile string too long");
		} else {
			debugln("tile string too short");
		}
#endif
		return false;
	}
	for (int face = 0; face < FACES_PER_CUBE; face++) {
		for (int tile = 0; tile < TILES_PER_FACE; tile++) {
			char *loc = strchr(key, tiles[face * TILES_PER_FACE + tile]);
			if (loc == NULL) return false;
			int color = loc - key;
			assert(color >= 0 && color < 6);
			cube->face[face].tile[tile] = color;
		}
	}
	return Cube_ValidateTiles(cube);
}
