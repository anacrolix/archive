#define ENTITY_GLOWMAG_FULL 77
#define ENTITY_GLOWCOLOR_WHITE 0xd7
#define ENTITY_LENGTH 150

const char g_szTibiaWndTitle[] = "Tibia";
const char g_szTibiaClassName[] = "TibiaClient";

struct Entity_t {
	DWORD dwId;
	char szName[32];
	DWORD[0x15];
	DWORD dwGlowMag;
	DWORD dwGlowColor;
	DWORD[0x8];
};

struct EntityArray_t {
	struct Entity_t entity[ENTITY_LENGTH];
};

struct EntityArray_t *tibiaMemory = (void *)0x605a30;