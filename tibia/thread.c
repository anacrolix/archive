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

HANDLE WINAPI CreateRemoteThread(
  HANDLE hProcess,
  LPSECURITY_ATTRIBUTES lpThreadAttributes,
  SIZE_T dwStackSize,
  LPTHREAD_START_ROUTINE lpStartAddress,
  LPVOID lpParameter,
  DWORD dwCreationFlags,
  LPDWORD lpThreadId
);

VOID WINAPI Sleep(
  DWORD dwMilliseconds
);

DWORD GetWindowThreadProcessId(

    HWND hWnd,
    LPDWORD lpdwProcessId
);

DWORD WINAPI ThreadProc(
  LPVOID lpParameter
);

HANDLE WINAPI OpenProcess(
  DWORD dwDesiredAccess,
  BOOL bInheritHandle,
  DWORD dwProcessId
);

HWND FindWindow(

    LPCTSTR lpClassName,
    LPCTSTR lpWindowName
);

BOOL WINAPI SetThreadPriority(
  HANDLE hThread,
  int nPriority
);
*/
DWORD WINAPI HackLight (LPVOID lpParam) {
	while (1) {
		Sleep (500);
	}
	return 0;
}

DWORD WINAPI StdOutSpammer (LPVOID lpParam) {
	int threadIndex = *((int*)lpParam);
	while (1) {
		Sleep(1000);
		printf("%d", threadIndex);
	}
	return 0;
}

int main(void) {
	//get handle to tibia window
	HWND hwnd_Tibia;
	hwnd_Tibia = FindWindow ("TibiaClient", NULL);
	if (hwnd_Tibia == NULL) {
		printf("Tibia client not found.\n");
		exit(0);
	}
	//get process id
	DWORD pid_Tibia;
	GetWindowThreadProcessId (hwnd_Tibia, &pid_Tibia);
	//get handle to tibia process
	HANDLE hProcess_Tibia = OpenProcess (PROCESS_ALL_ACCESS, FALSE, pid_Tibia);
	//create remote thread
	DWORD dwThreadId;
	CreateRemoteThread (
		hProcess_Tibia,
		NULL,
		0,
		HackLight,
		0,
		0,
		&dwThreadId);

	//WaitForSingleObject (&dwThreadId, 2000);
	printf("Light should now be injected.\n");
	//SetThreadPriority (hProcess_Tibia, THREAD_PRIORITY_LOWEST);
	CloseHandle (hProcess_Tibia);
	//while (1);
	return 0;
}



