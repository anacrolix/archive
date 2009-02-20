#include <windows.h>
#include <stdio.h>

HWND hwndTibia = 0;

BOOL CALLBACK EnumWindowsProc(HWND hwnd, LPARAM lParam) {
	printf("EnumWindowsProc(%u,%u);\n", hwnd, lParam);
	//check classname
	char szBuffer[0xff];
	static char szTibiaClassName[] = "TibiaClient";
	GetClassName(hwnd, szBuffer, 0xff);
	printf("GetClassName(%u, %s, %u);\n", hwnd, szBuffer, 0xff);
	if (strcmp(szBuffer, szTibiaClassName) != 0) return TRUE;
	//check window text
	static char szTibiaWindowText[] = "Tibia";
	GetWindowText(hwnd, szBuffer, 0xff);
	printf("GetWindowText(%u, %s, %u);\n", hwnd, szBuffer, 0xff);
	if (strncmp(szBuffer, szTibiaWindowText, strlen(szTibiaWindowText)) != 0) return TRUE;
	printf("All checks matched, hwndTibia updated\n");
	hwndTibia = hwnd;
	return TRUE;
}

int main (int argc, char** argv) {
	/*
	printf("Number of arguments: %d\n", argc);
	for (int i=0; i<argc;i++) {
		printf("Argument #%d: %s\n", i, argv[i]);
	}
	*/
	/*
	HWND FindWindowEx(

	    HWND hwndParent,
	    HWND hwndChildAfter,
	    LPCTSTR lpszClass,
	    LPCTSTR lpszWindow
	);
	*/
	/*
	BOOL EnumWindows(

	    WNDENUMPROC lpEnumFunc,
	    LPARAM lParam
	);
	BOOL CALLBACK EnumWindowsProc(

	    HWND hwnd,
	    LPARAM lParam
	);
	*/
	EnumWindows(EnumWindowsProc, 0);

	printf("EnumWindows returns %u\n", hwndTibia);
	return 0;
}


