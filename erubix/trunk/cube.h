#ifndef CUBE_H
#define CUBE_H

#include "eruutil/erudebug.h"

// MOVES

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

// TILES

#define TILES_PER_FACE 9
/* 0 1 2
 * 3 4 5
 * 6 7 8
 */
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

// FACES

#define FACES_PER_CUBE 6
enum Face_e {
	FACE_F,
	FACE_U,
	FACE_R,
	FACE_D,
	FACE_B,
	FACE_L
};
struct Face_t {
	char tile[TILES_PER_FACE];
};
typedef struct Face_t Face;
static_assert(sizeof(Face) == 9);

enum Rotation_e {
	ROTATE_ACW,
	ROTATE_CW
};

// CUBE

typedef struct Cube_t {
	struct Cube_t *parent;
	enum Move_e lastMove;
	unsigned depth;
	struct Face_t face[FACES_PER_CUBE];
	struct Cube_t *nextMove[UNIQUE_MOVES];
} Cube;

static_assert(sizeof(Cube) == 116);

#define EDGES_PER_FACE 4
extern const enum Face_e
EDGE_COMPASS[FACES_PER_CUBE][EDGES_PER_FACE];

#define TILES_PER_EDGE 3
extern const enum Tile_e
EDGE_MAPPING[FACES_PER_CUBE][EDGES_PER_FACE][TILES_PER_EDGE];

void Cube_Init(Cube *);
void Cube_Remove(Cube *);

#endif
