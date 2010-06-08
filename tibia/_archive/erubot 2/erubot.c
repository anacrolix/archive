#include <windows.h>
#include <stdio.h>
#include "resource.h"
#include "tibia.h"
#include <string.h>
#include <wininet.h>
#include <winhttp.h>

//#define WIN32_LEAN_AND_MEAN

//typedef VOID (*ProcessModifyFunc) (HANDLE);

UINT g_uLightTimerId = 0;

BOOL IsTibiaWindow(HWND hwnd) {
	const UINT lenResult = 100;
	char szResult[lenResult];
	if (!GetWindowText(hwnd, szResult, lenResult) //no window title
		|| !strstr(szResult, g_szTibiaWndTitle) //"Tibia" not found in window title
		|| !GetClassName(hwnd, szResult, lenResult) //no class name
		|| strncmp(szResult, g_szTibiaClassName, strlen(g_szTibiaClassName))) //classname not "TibiaClient"
		return FALSE;
	return TRUE;
}

HANDLE OpenProcessWindow(HWND hwnd) {
	DWORD dwProcessId;
	GetWindowThreadProcessId(hwnd, &dwProcessId);
	return OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwProcessId);
}

VOID SetFullLight (HANDLE hTibia) {
	DWORD dwGlowMag = ENTITY_GLOWMAG_FULL, dwGlowColor = ENTITY_GLOWCOLOR_WHITE;
	UINT i;
	struct EntityArray_t *local = GlobalAlloc(0, sizeof(struct EntityArray_t));
	ReadProcessMemory(hTibia, tibiaMemory, local, sizeof(*local), NULL);
	//printf("sizeof(*local)=%u\n", sizeof(*local));
	for (i = 0; i < ENTITY_LENGTH; i++) {
		if (!local->entity[i].dwId) continue;
		if (local->entity[i].dwGlowColor != ENTITY_GLOWCOLOR_WHITE) {
			WriteProcessMemory(hTibia, (LPVOID)(&tibiaMemory->entity[i].dwGlowColor), (LPVOID) &dwGlowColor, sizeof(dwGlowColor), NULL);
			//printf("Wrote dwGlowColor for %s\n", local->entity[i].szName);
		}
		if (local->entity[i].dwGlowMag != ENTITY_GLOWMAG_FULL) {
			WriteProcessMemory(hTibia, (LPVOID)(&tibiaMemory->entity[i].dwGlowMag), (LPVOID) &dwGlowMag, sizeof(dwGlowMag), NULL);
			//printf("Wrote dwGlowMag for %s\n", local->entity[i].szName);
		}
	}
	GlobalFree(local);
}

BOOL CALLBACK FullLightEnumWindowsProc (HWND hwnd, LPARAM lParam) {
	HANDLE hProcess;
	if (
		!IsTibiaWindow(hwnd)
		|| !(hProcess = OpenProcessWindow(hwnd))
		) return TRUE;
	//((VOID(*)(HANDLE))lParam)(hProcess);
	//((ProcessModifyFunc)lParam)(hProcess);
	SetFullLight(hProcess);
	CloseHandle(hProcess);
	return TRUE;
}

DWORD WINAPI FullLightThreadFunc(LPVOID lParam) {
/*
	LARGE_INTEGER liStartCount, liFinishCount, liFrequency;
	BOOL supported = QueryPerformanceCounter(&liStartCount);
*/
	//timed area
	EnumWindows(FullLightEnumWindowsProc, 0);
/*
	if (!supported) {
		MessageBox(NULL, "High resolution performance timer not supported", "Shit!", 0);
		return 0;
	}
	QueryPerformanceCounter(&liFinishCount);
	QueryPerformanceFrequency(&liFrequency);
	printf("Time taken to apply full light: %8.6f ms\n", (double)(liFinishCount.QuadPart - liStartCount.QuadPart) * (double)1000.0/(double)liFrequency.QuadPart);
*/
	return 0;
}

BOOL CALLBACK TibiaWndEnumProc(HWND hwnd, LPARAM lParam) {
	DWORD dwProcessId;
	GetWindowThreadProcessId(hwnd, &dwProcessId);
	HANDLE hTibia = OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwProcessId);
	if (hTibia == NULL) {
		MessageBox(NULL, "Failed to open process", "Shit!", 0);
		return TRUE;
	}
	CloseHandle(hTibia);
	return TRUE;
}

VOID CALLBACK LightTimerProc(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime) {
	if (!CreateThread(0, 0, FullLightThreadFunc, 0, 0, NULL)) MessageBox(NULL, "CreateThread fucked up", "Shit!", 0);
	return;
}

/*
BOOL CALLBACK TestKeydownEnumWindowsProc (HWND hwnd, LPARAM lParam) {
	if (!IsTibiaWindow(hwnd)) return TRUE;
	SendMessage(hwnd, WM_KEYDOWN, VK_CONTROL, 0);
	SendMessage(hwnd, WM_KEYDOWN, VK_F12, 0);
	SendMessage(hwnd, WM_KEYUP, VK_F12, 0);
	SendMessage(hwnd, WM_KEYUP, VK_CONTROL, 0);
	return TRUE;
}
*/
/*
VOID CALLBACK TestKeydownProc(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime) {
	//MessageBox(NULL, "KEYDOWNPROC", NULL, 0);
	EnumWindows(TestKeydownEnumWindowsProc, 0);
	return;
}
*/

BOOL CALLBACK MainDlgProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
	switch (uMsg) {
		case WM_INITDIALOG:
				//dialog init
				//SetTimer((NULL), 0, 5000, TestKeydownProc);
			return TRUE;
		case WM_COMMAND:
			switch (LOWORD(wParam)) { //relevant control id
				case IDC_CHKLIGHT:
					switch (HIWORD(wParam)) { //control action
						case BN_CLICKED:
							if (IsDlgButtonChecked(hwnd, IDC_CHKLIGHT) == BST_CHECKED) {
								if (g_uLightTimerId) break;
								g_uLightTimerId = SetTimer(NULL, 0, 500, LightTimerProc);
							} else {
								if (g_uLightTimerId) {
									KillTimer(NULL, g_uLightTimerId);
									g_uLightTimerId = 0;
								}
							}
							return TRUE;
					}
					break;
			}
		break;
		case WM_DESTROY:
			if (g_uLightTimerId) {
				KillTimer(hwnd, g_uLightTimerId);
				g_uLightTimerId = 0;
			}
			PostQuitMessage(0);
			return TRUE;
		case WM_CLOSE:
			DestroyWindow(hwnd);
			return TRUE;
	}
	return FALSE; //DefDlgProc called automatically
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	//inject test

	//create main dialog
	HWND hwndMainDlg = CreateDialog(hInstance, MAKEINTRESOURCE(IDD_MAIN), 0, MainDlgProc);
	if (!hwndMainDlg) {
		MessageBox(NULL, "Unable to create main dialog box!", "Shit!", MB_ICONEXCLAMATION|MB_OK);
		return 1;
	}
	//core message pump
	MSG msg;
	int status;
	while((status = GetMessage(&msg, NULL, 0, 0)) != 0)
	{
		if (status == -1) {
			MessageBox(NULL, "There was an error calling GetMessage", "Shit!", MB_ICONEXCLAMATION|MB_OK);
			return -1;
		} else if (!IsDialogMessage(hwndMainDlg, &msg)) {
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}
	//clean up and exit
	//MessageBox(NULL, "Visit joiner.id.au/forums for updates!", "Bye from Eru", MB_OK);
	return msg.wParam;
}

void testLib(void) {
	InternetOpen(NULL, INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0);
}