#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <error.h>
#include <assert.h>
#include "eruutil/erudebug.h"

#define MOVE_DEPTH 30

#define UNIQUE_MOVES 12
enum Move_e {
	MOVE_FCW,
	MOVE_FACW,
	MOVE_UCW,
	MOVE_UACW,
	MOVE_RCW,
	MOVE_RACW,
	MOVE_DCW,
	MOVE_DACW,
	MOVE_BCW,
	MOVE_BACW,
	MOVE_LCW,
	MOVE_LACW
};

#define FACES_PER_CUBE 6
enum Face_e {
	FACE_F,
	FACE_U,
	FACE_R,
	FACE_D,
	FACE_B,
	FACE_L
};

#define TILES_PER_FACE 9
enum Tile_e {
	TILE_TL,
	TILE_T,
	TILE_TR,
	TILE_L,
	TILE_C,
	TILE_R,
	TILE_BL,
	TILE_B,
	TILE_BR
};

enum Rotation_e {
	ROTATE_ACW,
	ROTATE_CW
};

struct Face_t {
	unsigned char tile[TILES_PER_FACE];
};
typedef struct Face_t Face;
static_assert(sizeof(Face) == 9);

struct Cube_t {
	struct Cube_t *parent;
	enum Move_e lastMove;
	unsigned depth;
	struct Face_t face[FACES_PER_CUBE];
	struct Cube_t *nextMove[UNIQUE_MOVES];
};
typedef struct Cube_t Cube;
static_assert(sizeof(Cube) == 116);

#define EDGES_PER_FACE 4
const enum Face_e EDGE_COMPASS[FACES_PER_CUBE][EDGES_PER_FACE] = {
	FACE_U, FACE_R, FACE_D, FACE_L, //F
	FACE_B, FACE_R, FACE_F, FACE_L, //U
	FACE_U, FACE_B, FACE_D, FACE_F, //R
	FACE_F, FACE_R, FACE_B, FACE_L, //D
	FACE_U, FACE_L, FACE_D, FACE_R, //B
	FACE_U, FACE_F, FACE_D, FACE_B  //L
};

#define TILES_PER_EDGE 3
const enum Tile_e
EDGE_MAPPING[FACES_PER_CUBE][EDGES_PER_FACE][TILES_PER_EDGE] =
{
	TILE_BL, TILE_B, TILE_BR,
	TILE_TL, TILE_L, TILE_BL,
	TILE_TR, TILE_T, TILE_TL,
	TILE_BR, TILE_R, TILE_TR,

	TILE_TR, TILE_T, TILE_TL,
	TILE_TR, TILE_T, TILE_TL,
	TILE_TR, TILE_T, TILE_TL,
	TILE_TR, TILE_T, TILE_TL,

	TILE_BR, TILE_R, TILE_TR,
	TILE_TL, TILE_L, TILE_BL,
	TILE_BR, TILE_R, TILE_TR,
	TILE_BR, TILE_R, TILE_TR,

	TILE_BL, TILE_B, TILE_BR,
	TILE_BL, TILE_B, TILE_BR,
	TILE_BL, TILE_B, TILE_BR,
	TILE_BL, TILE_B, TILE_BR,

	TILE_TR, TILE_T, TILE_TL,
	TILE_TL, TILE_L, TILE_BL,
	TILE_BL, TILE_B, TILE_BR,
	TILE_BR, TILE_R, TILE_TR,

	TILE_TL, TILE_L, TILE_BL,
	TILE_TL, TILE_L, TILE_BL,
	TILE_TL, TILE_L, TILE_BL,
	TILE_BR, TILE_R, TILE_TR
};

char const SOLVED_CUBE_STR[] =
	"FFFFFFFFF"
	"UUUUUUUUU"
	"RRRRRRRRR"
	"DDDDDDDDD"
	"BBBBBBBBB"
	"LLLLLLLLL";

struct Cube_t solvedCube;

const unsigned g_uMaxDepth = 20;
char startCube[] = "ffbffbffbuuduuduudrrrrrrrrrddudduddufbbfbbfbblllllllll";
struct Cube_t rootCube;

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
	//newFace->tile[TILE_C] = oldFace->tile[TILE_C];
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
	//newFace->tile[TILE_C] = oldFace->tile[TILE_C];
	newFace->tile[TILE_R] = oldFace->tile[TILE_B];
	newFace->tile[TILE_BL] = oldFace->tile[TILE_TL];
	newFace->tile[TILE_B] = oldFace->tile[TILE_L];
	newFace->tile[TILE_BR] = oldFace->tile[TILE_BL];
	return;
}

void moveEdges(
	struct Cube_t *oldCube,
	struct Cube_t *newCube,
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

inline bool compareCube(struct Cube_t *cubeOne, struct Cube_t *cubeTwo)
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

void pruneCube(struct Cube_t *cube)
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
bool validateCube(struct Cube_t *testCube, struct Cube_t *newCube)
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

void moveCube(struct Cube_t *thisCube, struct Cube_t *parentCube, enum Move_e thisMove)
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

void printMoveSequence(struct Cube_t *c)
{
	if (c->parent != NULL)
		printMoveSequence(c->parent);
	else
		return;
	printf(", %d", c->lastMove);
	return;
}

void printCube(struct Cube_t *cube)
{
	int i, j, f;
	for (i=0;i<3;i++) {
		for (f=0;f<FACES_PER_CUBE;f++) {
			for (j=0;j<3;j++) {
				putchar('0'+cube->face[f].tile[i*3+j]);
			}
			putchar(' ');
		}
		putchar('\n');
	}
	return;
}

void destroyBranch(struct Cube_t *cube)
{
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		if (cube->nextMove[m]) destroyBranch(cube->nextMove[m]);
	}
	//GlobalFree(cube);
	free(cube);
}

void pruneClones(struct Cube_t *orig, struct Cube_t *cube)
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

bool isFirst(struct Cube_t *cube, struct Cube_t *query)
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

struct Cube_t *expandGeneration(struct Cube_t *cube, unsigned generation)
{
	int m;
	struct Cube_t *result, *child;
	if (cube->depth < generation) {
		//traverse
		for (m = 0; m < UNIQUE_MOVES; m++) {
			if (cube->nextMove[m] == NULL) continue;
			result = expandGeneration(cube->nextMove[m], generation);
			if (result != NULL) return result;
		}
	} else if (cube->depth == generation) {
		//expand generation
		for (m = 0; m < UNIQUE_MOVES; m++) {
			//child = GlobalAlloc(0, sizeof(struct Cube_t));
			child = calloc(1, sizeof(struct Cube_t));
			//ZeroMemory(child, sizeof(struct Cube_t));
			//CopyMemory(&child->face, &cube->face, sizeof(struct Face_t[FACES_PER_CUBE]));
			memcpy(
				&child->face,
				&cube->face,
				sizeof(struct Face_t[FACES_PER_CUBE]));
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
		//MessageBox(NULL, "something really fucked up here", NULL, 0);
		//exit(0);
		fatal(0, "Something reallly fucked up here");
	}
	return NULL;
}

void expandCube(struct Cube_t *cube)
{
	#if LEVEL > DEBUG_WARN
	printf("expandCube()\n");
	#endif
	if (cube->depth >= g_uMaxDepth) return;
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		//struct Cube_t *childCube = GlobalAlloc(0, sizeof(struct Cube_t));
		struct Cube_t *childCube = malloc(sizeof(struct Cube_t));
		//CopyMemory(childCube, cube, sizeof(struct Cube_t));
		memcpy(childCube, cube, sizeof(struct Cube_t));
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

void generateCube(struct Cube_t *parentCube, enum Move_e thisMove)
{
	struct Cube_t *thisCube;
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
	//thisCube = GlobalAlloc(0, sizeof(struct Cube_t));
	thisCube = malloc(sizeof(struct Cube_t));
	//generate new cube
	//CopyMemory(thisCube, parentCube, sizeof(struct Cube_t));
	memcpy(thisCube, parentCube, sizeof(struct Cube_t));
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
	if (thisCube->depth >= g_uMaxDepth) return;
	int m;
	for (m=0;m<UNIQUE_MOVES;m++) {
		generateCube(thisCube, m);
	}
	return;
}

bool GetFacesString(struct Cube_t *c, const char *s)
{
	int f, t; // face, tile

	if (strlen(s) != FACES_PER_CUBE * TILES_PER_FACE) {
		fatal(0, "Cube string has invalid length: %s", s);
		return false;
	}

	for (f=0; f < FACES_PER_CUBE; f++) {
		for (t=0; t < TILES_PER_FACE; t++) {
			int x = toupper(s[f * TILES_PER_FACE + t]);
			assert(isalnum(x));
			switch (x) {
				case 'F':
				case '0':
				case 0:
					c->face[f].tile[t] = FACE_F;
					break;
				case 'T':
				case 'U':
				case '1':
				case 1:
					c->face[f].tile[t] = FACE_U;
					break;
				case 'R':
				case '2':
				case 2:
					c->face[f].tile[t] = FACE_R;
					break;
				case 'A':
				case 'B':
				case '3':
				case 3:
					c->face[f].tile[t] = FACE_B;
					break;
				case 'D':
				case '4':
				case 4:
					c->face[f].tile[t] = FACE_D;
					break;
				case 'L':
				case '5':
				case 5:
					c->face[f].tile[t] = FACE_L;
					break;
				default:
					fatal(0, "Unrecognized face value: %c", x);
					return false;
			}
		}
	}
	return true;
}

unsigned countCubes(struct Cube_t *cube, unsigned generation)
{
	int m;
	unsigned count = 0;
	for (m = 0; m < UNIQUE_MOVES; m++) {
		if (cube->nextMove[m] != NULL) count += countCubes(cube->nextMove[m], generation);
	}
	return (cube->depth == generation || generation == -1 ? 1 : 0) + count;
}

void transformCube(struct Cube_t *cube, enum Move_e move)
{
	//struct Cube_t *orig = GlobalAlloc(0, sizeof(struct Cube_t));
	struct Cube_t *orig = malloc(sizeof(struct Cube_t));
	//CopyMemory(orig, cube, sizeof(struct Cube_t));
	memcpy(orig, cube, sizeof(struct Cube_t));
	moveCube(cube, orig, move);
	//GlobalFree(orig);
	free(orig);
	return;
}

void cube_init(Cube *cube)
{
	cube->parent = NULL;
	cube->lastMove = -1;
}

int main(int argc, char *argv[])
{
	debug_size(rootCube.face);
	debug_size(Cube);
	memset(&rootCube, '\0', sizeof(rootCube));
	rootCube.parent = NULL;
	rootCube.lastMove = -1;
	rootCube.depth = 0;
	GetFacesString(&rootCube, startCube);
	printf("starting cube\n");
	printCube(&rootCube);
	//initialize solved cube
	GetFacesString(&solvedCube, SOLVED_CUBE_STR);
	printf("target solution\n");
	printCube(&solvedCube);
	struct Cube_t test;
	//CopyMemory(&test, &solvedCube, sizeof(struct Cube_t));
	memcpy(&test, &solvedCube, sizeof(struct Cube_t));
	transformCube(&test, MOVE_RACW);
	transformCube(&test, MOVE_RACW);
	transformCube(&test, MOVE_LACW);
	transformCube(&test, MOVE_BCW);
	transformCube(&test, MOVE_LACW);
	transformCube(&test, MOVE_BACW);
	transformCube(&test, MOVE_BCW);
	transformCube(&test, MOVE_LACW);
	transformCube(&test, MOVE_BACW);
	transformCube(&test, MOVE_LACW);
	//transformCube(&test, MOVE_BACW);
	printf("test cube\n");
	printCube(&test);
	//CopyMemory(&rootCube, &test, sizeof(struct Cube_t));
	memcpy(&rootCube, &test, sizeof(struct Cube_t));
	int g;
	struct Cube_t *result;
	//LARGE_INTEGER liStart, liFinish, liFrequency;
	//QueryPerformanceFrequency(&liFrequency);
	for (g=0;g<g_uMaxDepth;g++) {
		//QueryPerformanceCounter(&liStart);
		result = expandGeneration(&rootCube, g);
		if (result != NULL) break;
		//QueryPerformanceCounter(&liFinish);
		//printf("Cubes at generation %3u: %10u (new: %10u); time taken: %8.6f s\n", g, countCubes(&rootCube, -1), countCubes(&rootCube, g+1), (double)(liFinish.QuadPart-liStart.QuadPart)/(double)liFrequency.QuadPart);
	}
	if (result != NULL) {
		printMoveSequence(result);
		putchar('\n');
		printCube(result);
	} else {
		printf("no solution found\n");
	}
	pause();
	return 0;
}
