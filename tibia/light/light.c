#include <windows.h>
#include <stdio.h>

#define LIGHT_INTERVAL 500

#define ADR_CHAR 0x5A3CA0

#define ADR_PLAYER_ID ADR_CHAR - 0x64

#define LEN_CHAR 149
#define SIZE_CHAR 156

#define OS_CHAR_ID 0
#define OS_CHAR_LIGHT 0x74
#define OS_CHAR_COLOR 0x78

const DWORD LIGHT_WHITE = 0xD7;
const DWORD LIGHT_FULL = 77;

HANDLE tibiaHandle;
int playerIndex = -1;

void ReadMem(HANDLE pHandle, DWORD address, void* buffer, DWORD size) {
	ReadProcessMemory(pHandle, (void*)address, buffer, size, 0);
	return;
}

void WriteMem(HANDLE pHandle, DWORD address, void* buffer, DWORD size) {
	WriteProcessMemory(pHandle, (void*)address, buffer, size, 0);
	return;
}

int getPlayerIndex(void) {
  DWORD id, id2;
  ReadMem(tibiaHandle, ADR_PLAYER_ID, &id, 4);
  if (id == 0) return -1;
  if (playerIndex >= 0) {
		ReadMem(tibiaHandle, ADR_CHAR + OS_CHAR_ID + playerIndex * SIZE_CHAR, &id2, 4);
		if (id == id2) return playerIndex;
	}
	for (int i = 0; i < LEN_CHAR; i++) {
		ReadMem(tibiaHandle, ADR_CHAR + OS_CHAR_ID + i * SIZE_CHAR, &id2, 4);
		if (id == id2) {
			playerIndex = i;
			return playerIndex;
		}
	}
	return -1;
}

void FullLight(void) {
	getPlayerIndex();
	if (playerIndex < 0) return;
	WriteMem(tibiaHandle, (DWORD)(ADR_CHAR + OS_CHAR_LIGHT + playerIndex * SIZE_CHAR), (LPVOID)&LIGHT_FULL, 4);
	WriteMem(tibiaHandle, (DWORD)(ADR_CHAR + OS_CHAR_COLOR + playerIndex * SIZE_CHAR), (LPVOID)&LIGHT_WHITE, 4);
}

int main(void) {
	printf("EruBot II 0.1\nSearching for client...\n");

	HWND tibiaWindow;
  tibiaWindow = FindWindow("tibiaclient", NULL);

  DWORD pid;
  GetWindowThreadProcessId(tibiaWindow, &pid);

  tibiaHandle = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pid);

  if (tibiaHandle) {
		printf("Client found. Modifying light\n");
		while (1)
			{
				FullLight();
				printf("playerIndex = %d\n", playerIndex);
				sleep(LIGHT_INTERVAL);
			}
	} else {
		printf("Client not found. Closing...");
	}
	system("pause");
	return 0;
}



