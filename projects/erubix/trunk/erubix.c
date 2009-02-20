#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <error.h>
#include <assert.h>
#include "eruutil/erudebug.h"
#include "cube.h"

#define MOVE_DEPTH 30

char const SOLVED_CUBE_STR[] =
	"FFFFFFFFF"
	"UUUUUUUUU"
	"RRRRRRRRR"
	"DDDDDDDDD"
	"BBBBBBBBB"
	"LLLLLLLLL";

Cube solvedCube;

//const unsigned g_uMaxDepth = 20;
//char startCube[] = "ffbffbffbuuduuduudrrrrrrrrrddudduddufbbfbbfbblllllllll";
Cube rootCube;

void pause(void)
{
	int c;
	do {
		c = getchar();
	} while (c != EOF && c != '\n');
	return;
}

void rotateCW(struct Face_t *oldFace, struct Face_t *newFace)
{
	newFace->tile[TILE_TL] = oldFace->tile[TILE_BL];
	newFace->tile[TILE_T] = oldFace->tile[TILE_L];
	newFace->tile[TILE_TR] = oldFace->tile[TILE_TL];
	newFace->tile[TILE_L] = oldFace->tile[TILE_B];
	newFace->tile[TILE_C] = oldFace->tile[TILE_C];
	newFace->tile[TILE_R] = oldFace->tile[TILE_T];
	newFace->tile[TILE_BL] = oldFace->tile[TILE_BR];
	newFace->tile[TILE_B] = oldFace->tile[TILE_R];
	newFace->tile[TILE_BR] = oldFace->tile[TILE_TR];
	return;
}

void rotateACW(struct Face_t *oldFace, struct Face_t *newFace)
{
	newFace->tile[TILE_TL] = oldFace->tile[TILE_TR];
	newFace->tile[TILE_T] = oldFace->tile[TILE_R];
	newFace->tile[TILE_TR] = oldFace->tile[TILE_BR];
	newFace->tile[TILE_L] = oldFace->tile[TILE_T];
	newFace->tile[TILE_C] = oldFace->tile[TILE_C];
	newFace->tile[TILE_R] = oldFace->tile[TILE_B];
	newFace->tile[TILE_BL] = oldFace->tile[TILE_TL];
	newFace->tile[TILE_B] = oldFace->tile[TILE_L];
	newFace->tile[TILE_BR] = oldFace->tile[TILE_BL];
	return;
}

void moveEdges(
	Cube *oldCube,
	Cube *newCube,
	enum Face_e face,
	enum Rotation_e direction)
{
	int e, t;
	for (e = 0; e < EDGES_PER_FACE; e++) {
		for (t=0;t<TILES_PER_EDGE;t++) {
			newCube
				->face[EDGE_COMPASS[face][e]]
				.tile[EDGE_MAPPING[face][e][t]]
				=
			oldCube
				->face[EDGE_COMPASS[face][(EDGES_PER_FACE+e+(direction==ROTATE_CW?1:-1))%EDGES_PER_FACE]]
				.tile[EDGE_MAPPING[face][(EDGES_PER_FACE+e+(direction==ROTATE_CW?1:-1))%EDGES_PER_FACE][t]];
		}
	}
	return;
}

inline bool compareCube(Cube *cubeOne, Cube *cubeTwo)
{
	if (!memcmp(cubeOne->face, cubeTwo->face, sizeof(cubeOne->face))) {
		return true;
	} else {
		return false;
	}
/*
	int f, t;
	for (f=0;f<FACES_PER_CUBE;f++) {
		for (t=0;t<TILES_PER_FACE;t++) {
			//DEBUG printf("checking face %d tile %d\n", f, t);
			if (cubeOne->face[f].tile[t] != cubeTwo->face[f].tile[t]) return FALSE;
		}
	}
*/
}

void pruneCube(Cube *cube)
{
	//sever parent
	if (cube->parent) {
		if (cube->parent->nextMove[cube->lastMove] != cube) {
			//MessageBox(NULL, "Parent cube does not recognise child", NULL, 0);
			fatal(0, "Parent cube does not recognise child");
		}
		cube->parent->nextMove[cube->lastMove] = NULL;
	}
	int m;
	//prune children
	for (m=0;m<UNIQUE_MOVES;m++) {
		if (cube->nextMove[m]) pruneCube(cube->nextMove[m]);
	}
	//kill self
	//GlobalFree(cube);
	free(cube);
}

//return false if there is a younger version of this cube, prune older versions on the way
bool validateCube(Cube *testCube, Cube *newCube)
{
	debug("validateCube()\n");
	if (testCube->depth != 0 && compareCube(testCube, newCube)) {
		debug("test cube matches new cube\n");
		if (testCube->depth <= newCube->depth) return false;
		pruneCube(testCube);
		return true;
	}
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		if (testCube->nextMove[m]) {
			if (!validateCube(testCube->nextMove[m], newCube)) return false;
		}
	}
	return true;
}

void moveCube(Cube *thisCube, Cube *parentCube, enum Move_e thisMove)
{
	switch (thisMove) {
		case MOVE_FCW:
			rotateCW(&parentCube->face[FACE_F], &thisCube->face[FACE_F]);
			moveEdges(parentCube, thisCube, FACE_F, ROTATE_CW);
			break;
		case MOVE_FACW:
			rotateACW(&parentCube->face[FACE_F], &thisCube->face[FACE_F]);
			moveEdges(parentCube, thisCube, FACE_F, ROTATE_ACW);
			break;
		case MOVE_UCW:
			rotateCW(&parentCube->face[FACE_U], &thisCube->face[FACE_U]);
			moveEdges(parentCube, thisCube, FACE_U, ROTATE_CW);
			break;
		case MOVE_UACW:
			rotateACW(&parentCube->face[FACE_U], &thisCube->face[FACE_U]);
			moveEdges(parentCube, thisCube, FACE_U, ROTATE_ACW);
			break;
		case MOVE_RCW:
			rotateCW(&parentCube->face[FACE_R], &thisCube->face[FACE_R]);
			moveEdges(parentCube, thisCube, FACE_R, ROTATE_CW);
			break;
		case MOVE_RACW:
			rotateACW(&parentCube->face[FACE_R], &thisCube->face[FACE_R]);
			moveEdges(parentCube, thisCube, FACE_R, ROTATE_ACW);
			break;
		case MOVE_DCW:
			rotateCW(&parentCube->face[FACE_D], &thisCube->face[FACE_D]);
			moveEdges(parentCube, thisCube, FACE_D, ROTATE_CW);
			break;
		case MOVE_DACW:
			rotateACW(&parentCube->face[FACE_D], &thisCube->face[FACE_D]);
			moveEdges(parentCube, thisCube, FACE_D, ROTATE_ACW);
			break;
		case MOVE_BCW:
			rotateCW(&parentCube->face[FACE_B], &thisCube->face[FACE_B]);
			moveEdges(parentCube, thisCube, FACE_B, ROTATE_CW);
			break;
		case MOVE_BACW:
			rotateACW(&parentCube->face[FACE_B], &thisCube->face[FACE_B]);
			moveEdges(parentCube, thisCube, FACE_B, ROTATE_ACW);
			break;
		case MOVE_LCW:
			rotateCW(&parentCube->face[FACE_L], &thisCube->face[FACE_L]);
			moveEdges(parentCube, thisCube, FACE_L, ROTATE_CW);
			break;
		case MOVE_LACW:
			rotateACW(&parentCube->face[FACE_L], &thisCube->face[FACE_L]);
			moveEdges(parentCube, thisCube, FACE_L, ROTATE_ACW);
			break;
		default:
			//MessageBox(NULL, "Illegal move attempted", "wtf", 0);
			fatal(0, "Illegal move attempted");
	}
}

void printMoveSequence(Cube *c)
{
	if (c->parent != NULL)
		printMoveSequence(c->parent);
	else
		return;
	printf("%s ", Move_str[c->lastMove]);
	//printf(", %d", c->lastMove);
	return;
}

void printCube(Cube *cube)
{
	for (int i = 0; i < 3; i++) {
		for (int f = 0; f < FACES_PER_CUBE; f++) {
			for (int j = 0; j < 3; j++) {
				putchar('0' + cube->face[f].tile[i * 3 + j]);
			}
			putchar(' ');
		}
		putchar('\n');
	}
	return;
}

void destroyBranch(Cube *cube)
{
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		if (cube->nextMove[m]) destroyBranch(cube->nextMove[m]);
	}
	//GlobalFree(cube);
	free(cube);
}

void pruneClones(Cube *orig, Cube *cube)
{
	if (cube->depth > orig->depth) {
		if (compareCube(orig, cube)) {
			cube->parent->nextMove[cube->lastMove] = NULL;
			destroyBranch(cube);
			return;
		}
	}
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		if (cube->nextMove[m]) pruneClones(orig, cube->nextMove[m]);
	}
	return;
}

bool isFirst(Cube *cube, Cube *query)
{
	if (compareCube(cube, query)) return false;
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		if (cube->nextMove[m] != NULL) {
			if (!isFirst(query, cube->nextMove[m])) return false;
		}
	}
	return true;
}

Cube *expandGeneration(Cube *cube, unsigned gen)
{
	Cube *result, *child;
	if (cube->depth < gen) {
		//traverse
		for (int m = 0; m < UNIQUE_MOVES; m++) {
			if (cube->nextMove[m] == NULL) continue;
			result = expandGeneration(cube->nextMove[m], gen);
			if (result != NULL) return result;
		}
	} else if (cube->depth == gen) {
		//expand generation
		for (int m = 0; m < UNIQUE_MOVES; m++) {
			assert(cube->nextMove[m] == NULL);
			child = Cube_New();
			verify(memcpy(child->face, cube->face, sizeof(child->face)) == child->face);
			moveCube(child, cube, m);
			child->parent = cube;
			child->lastMove = m;
			child->depth = cube->depth + 1;
			if (compareCube(child, &solvedCube)) {
				cube->nextMove[m] = child;
				return child;
			}
			//if (FALSE) {
			if (!isFirst(&rootCube, child)) {
				//GlobalFree(child);
				free(child);
				continue;
			} else {
				cube->nextMove[m] = child;
			}
		}
	} else {
		fatal(0, "Something really fucked up here");
	}
	return NULL;
}

void expandCube(Cube *cube)
{
	//if (cube->depth >= g_uMaxDepth) return;
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		//Cube *childCube = GlobalAlloc(0, sizeof(Cube));
		Cube *childCube = malloc(sizeof(Cube));
		//CopyMemory(childCube, cube, sizeof(Cube));
		memcpy(childCube, cube, sizeof(Cube));
		debug("moveCube() %u\n", m);
		moveCube(cube, childCube, m);
		if (!isFirst(childCube, &rootCube)) {
			debug("cube was not first\n");
			//GlobalFree(childCube);
			free(childCube);
			continue;
		}
		pruneClones(childCube, &rootCube);
		childCube->parent = cube;
		childCube->lastMove = m;
		childCube->depth = cube->depth + 1;
		//ZeroMemory(&(childCube->nextMove), sizeof(childCube->nextMove));
		memset(&childCube->nextMove, '\0', sizeof(childCube->nextMove));
		cube->nextMove[m] = childCube;
#ifndef NDEBUG
		printMoveSequence(childCube);
		putchar('\n');
		printCube(childCube);
#endif
		if (compareCube(childCube, &solvedCube)) {
			printMoveSequence(childCube);
			printCube(childCube);
			printf("SOLUTION\n");
			exit(0);
		} else {
			expandCube(childCube);
		}
	}
}

void generateCube(Cube *parentCube, enum Move_e thisMove)
{
	Cube *thisCube;
#ifndef NDEBUG
	printMoveSequence(parentCube);
	debug(", %d\n", thisMove);
#endif
	if (thisMove == -1) {
		debug("cube is root\n");
		thisCube = parentCube;
		goto justmove;
	}
	//alloc space for new cube
	//thisCube = GlobalAlloc(0, sizeof(Cube));
	thisCube = malloc(sizeof(Cube));
	//generate new cube
	//CopyMemory(thisCube, parentCube, sizeof(Cube));
	memcpy(thisCube, parentCube, sizeof(Cube));
	thisCube->depth = parentCube->depth + 1;

	moveCube(parentCube, thisCube, thisMove);
	//check cube validity
	debug("validating cube\n");
	if (!validateCube(&rootCube, thisCube)) {
		//GlobalFree(thisCube);
		free(thisCube);
		return;
	}
	//take action and set handles
	//ZeroMemory(&thisCube->nextMove, sizeof(thisCube->nextMove));
	memset(&thisCube->nextMove, '\0', sizeof(thisCube->nextMove));
	thisCube->parent = parentCube;
	thisCube->lastMove = thisMove;
	parentCube->nextMove[thisMove] = thisCube;
	//make additional moves if appropriate
justmove:
	debug("checking if cube is solution\n");
	if (compareCube(thisCube, &solvedCube)) {
		printf("cube matched solution\n");
		printMoveSequence(thisCube);
		printf("\n");
		printCube(thisCube);
		pause();
		return;
	}
	//if (thisCube->depth >= g_uMaxDepth) return;
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		generateCube(thisCube, m);
	}
	return;
}

unsigned countCubes(Cube *cube, unsigned generation)
{
	int m;
	unsigned count = 0;
	for (m = 0; m < UNIQUE_MOVES; m++) {
		if (cube->nextMove[m] != NULL) count += countCubes(cube->nextMove[m], generation);
	}
	return (cube->depth == generation || generation == -1 ? 1 : 0) + count;
}

void transformCube(Cube *cube, enum Move_e move)
{
	//Cube *orig = GlobalAlloc(0, sizeof(Cube));
	Cube *orig = malloc(sizeof(Cube));
	//CopyMemory(orig, cube, sizeof(Cube));
	memcpy(orig, cube, sizeof(Cube));
	moveCube(cube, orig, move);
	//GlobalFree(orig);
	free(orig);
	return;
}

int main(int argc, char *argv[])
{
	// check some type sizes
	debug_size(rootCube.face);
	debug_size(Cube);
	debug("\n");

	// initialize solved cube
	Cube_Init(&solvedCube);
	if (!Cube_LoadTiles(&solvedCube, SOLVED_CUBE_STR, "FURDBL")) {
		fatal(0, "Failed to load solved cube");
	}
	printf("Target solution:\n");
	printCube(&solvedCube);
	putchar('\n');

	// initialize problem cube
	Cube_Init(&rootCube);
	rootCube.depth = 0;
	assert(sizeof(rootCube.face) == sizeof(solvedCube.face));
	verify(memcpy(rootCube.face, solvedCube.face, sizeof(rootCube.face)) == rootCube.face);
	transformCube(&rootCube, MOVE_RACW);
	transformCube(&rootCube, MOVE_RACW);
	transformCube(&rootCube, MOVE_LACW);
	transformCube(&rootCube, MOVE_BCW);
	transformCube(&rootCube, MOVE_LACW);
	transformCube(&rootCube, MOVE_BACW);
	transformCube(&rootCube, MOVE_BCW);
	transformCube(&rootCube, MOVE_LACW);
	transformCube(&rootCube, MOVE_BACW);
	//transformCube(&rootCube, MOVE_LACW);
	//transformCube(&rootCube, MOVE_BACW);
	verify(Cube_ValidateTiles(&rootCube));
	printf("Cube initial state:\n");
	printCube(&rootCube);
	putchar('\n');

	// solve cube
	Cube *result;
	for (int gen = 0; gen < 8; gen++) {
		result = expandGeneration(&rootCube, gen);
		if (result != NULL) break;
		printf("Generation %2d: %10u cubes (%10u new)\n", gen, countCubes(&rootCube, -1), countCubes(&rootCube, gen + 1));
	}
	if (result != NULL) {
		printMoveSequence(result);
		putchar('\n');
		printCube(result);
	} else {
		printf("no solution found\n");
	}
	//pause();
	return 0;
}
