#include <windows.h>
#include <stdio.h>
#include <string.h>

#define GAME_STATUS_CONNECTED 8
#define CHECK_INTERVAL 1000
#define BEEP_DURATION 400
#define BEEP_FREQUENCY 400

const DWORD * ADR_GAMESTATUS = (DWORD *)0x751b78;
const char * TIBIA_CLASSNAME = "TibiaClient";
const char * TIBIA_WINDOWTEXT = "Tibia";

HWND hwndTibia;

void err_quit (char *quitReason) {
	printf(quitReason);
	putchar('\n');
	system("pause");
	exit (EXIT_FAILURE);
}

void syserr_quit (char *callName) {
	perror(callName);
	system("pause");
	exit (EXIT_FAILURE);
}

BOOL CALLBACK EnumTibiaWindowsProc (HWND hwnd, LPARAM lparam) {
	char strClassName[strlen(TIBIA_CLASSNAME)];
	GetClassName(hwnd, strClassName, strlen(TIBIA_CLASSNAME));
	if (strncmp(strClassName, TIBIA_CLASSNAME, strlen(TIBIA_CLASSNAME) - 1) != 0) return TRUE;
	char strWindowText[strlen(TIBIA_WINDOWTEXT)];
	GetWindowText(hwnd, strWindowText, strlen(TIBIA_WINDOWTEXT));
	if (strncmp(strWindowText, TIBIA_WINDOWTEXT, strlen(TIBIA_WINDOWTEXT) - 1) != 0) return TRUE;
	hwndTibia = hwnd;
	return TRUE;
}

void FindTibiaWindow (void) {
	hwndTibia = NULL;
	if (EnumWindows(EnumTibiaWindowsProc, 0) == 0) syserr_quit("EnumWindows");
	if (hwndTibia == NULL) err_quit("No tibia client found");
	return;
}

int main (void) {
	for (;;) {
		FindTibiaWindow();
		DWORD pid;
		GetWindowThreadProcessId(hwndTibia, &pid);
		//if (pid == NULL) syserr_quit("GetWindowThreadProcessId");
		HANDLE handle = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pid);
		if (handle == NULL) syserr_quit("OpenProcess");
		DWORD gameStatus;
		if (ReadProcessMemory(handle, ADR_GAMESTATUS, &gameStatus, sizeof(DWORD), NULL) == 0)
			syserr_quit("ReadProcessMemory");
		if (gameStatus != GAME_STATUS_CONNECTED) {
			Beep(BEEP_FREQUENCY, BEEP_DURATION);
			Sleep(CHECK_INTERVAL - BEEP_DURATION);
		} else {
			Sleep(CHECK_INTERVAL);
		}
	}
	return 0;
}
