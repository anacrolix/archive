#include <windows.h>
#include <stdio.h>

const int SHOW_NAMES					= 0x004D7FFD; // writeNops 2
const int SHOW_NAMES_EX					= 0x004D8007; // writeNops 2

const int SHOW_NAMES_DEFAULT	= 19573; // default values before nop; integer 2 bytes
const int SHOW_NAMES_EX_DEFAULT	= 17013;

void err_sys (char *reason) {
	printf("%s\n", reason);
	system("pause");
	exit (EXIT_FAILURE);
}

int main (void) {
	HWND hwndTibia = FindWindow("TibiaClient", NULL);
	if (hwndTibia == NULL) err_sys("FindWindow");
	DWORD pid;
	GetWindowThreadProcessId (hwndTibia, &pid);
	printf("pid=%u\n", pid);
	HANDLE hTibia = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pid);
	if (hTibia == NULL) err_sys("OpenProcess");
	unsigned int nop = 0x9090;
	WriteProcessMemory (hTibia, (void *)SHOW_NAMES, (void *)&nop, 2, NULL);
	//WriteProcessMemory (hTibia, (void *)SHOW_NAMES_EX, (void *)&nop, 2, NULL);
	system("pause");
	return 0;
}
