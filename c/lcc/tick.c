#include <windows.h>
#include <stdio.h>
/*
HANDLE WINAPI CreateThread(
  LPSECURITY_ATTRIBUTES lpThreadAttributes,
  SIZE_T dwStackSize,
  LPTHREAD_START_ROUTINE lpStartAddress,
  LPVOID lpParameter,
  DWORD dwCreationFlags,
  LPDWORD lpThreadId
);
*/

int main(void) {
	DWORD ticks = GetTickCount();
	printf("System tick count: %u\n",ticks);
	printf("Last Reboot: %u hour(s) ago\n", ticks/3600000);
	printf("Next tick rollover in: %u hours(s)\n", (ULONG_MAX - ticks) / 3600000);
	system("pause");
	return 0;
}



