#include <windows.h>

#define EXP_HISTORY 30
#define EXP_GRANULARITY 20000

/*  Declare Windows procedure  */
LRESULT CALLBACK WindowProcedure (HWND, UINT, WPARAM, LPARAM);
BOOL IsTibiaWnd (HWND);
HWND GetTibiaWnd (HWND);
VOID CALLBACK ExpTimerProc (HWND, UINT, UINT_PTR, DWORD);

/*  Make the class name into a global variable  */
char szClassName[ ] = "Erubot3";
UINT uExpTimerId = 0;
DWORD dwExp[EXP_HISTORY];
unsigned int uExpIndex = 0;

int WINAPI WinMain (HINSTANCE hThisInstance,
                    HINSTANCE hPrevInstance,
                    LPSTR lpszArgument,
                    int nFunsterStil)

{
    HWND hwnd;               /* This is the handle for our window */
    MSG messages;            /* Here messages to the application are saved */
    WNDCLASSEX wincl;        /* Data structure for the windowclass */

    /* The Window structure */
    wincl.hInstance = hThisInstance;
    wincl.lpszClassName = szClassName;
    wincl.lpfnWndProc = WindowProcedure;      /* This function is called by windows */
    wincl.style = CS_DBLCLKS;                 /* Catch double-clicks */
    wincl.cbSize = sizeof (WNDCLASSEX);

    /* Use default icon and mouse-pointer */
    wincl.hIcon = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hIconSm = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hCursor = LoadCursor (NULL, IDC_ARROW);
    wincl.lpszMenuName = NULL;                 /* No menu */
    wincl.cbClsExtra = 0;                      /* No extra bytes after the window class */
    wincl.cbWndExtra = 0;                      /* structure or the window instance */
    /* Use Windows's default color as the background of the window */
    wincl.hbrBackground = (HBRUSH) COLOR_BACKGROUND;

    /* Register the window class, and if it fails quit the program */
    if (!RegisterClassEx (&wincl))
        return 0;

    /* The class is registered, let's create the program*/
    hwnd = CreateWindowEx (
           0,                   /* Extended possibilites for variation */
           szClassName,         /* Classname */
           "Erubot3 for Tibia 8.0",       /* Title Text */
           WS_SYSMENU | WS_MINIMIZEBOX, /* default window */
           CW_USEDEFAULT,       /* Windows decides the position */
           CW_USEDEFAULT,       /* where the window ends up on the screen */
           300,                 /* The programs width */
           200,                 /* and height in pixels */
           HWND_DESKTOP,        /* The window is a child-window to desktop */
           NULL,                /* No menu */
           hThisInstance,       /* Program Instance handler */
           NULL                 /* No Window Creation data */
           );

    /* Make the window visible on the screen */
    ShowWindow (hwnd, nFunsterStil);

    /* Run the message loop. It will run until GetMessage() returns 0 */
    while (GetMessage (&messages, NULL, 0, 0))
    {
        /* Translate virtual-key messages into character messages */
        TranslateMessage(&messages);
        /* Send message to WindowProcedure */
        DispatchMessage(&messages);
    }

    /* The program return-value is 0 - The value that PostQuitMessage() gave */
    return messages.wParam;
}


/*  This function is called by the Windows function DispatchMessage()  */

LRESULT CALLBACK WindowProcedure (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)                  /* handle the messages */
    {
		case WM_CREATE:
			uExpTimerId = SetTimer(NULL, 0, EXP_GRANULARITY, ExpTimerProc);
			ZeroMemory(dwExp, sizeof(dwExp));
			break;
        case WM_DESTROY:
            PostQuitMessage (0);       /* send a WM_QUIT to the message queue */
            break;
        default:                      /* for messages that we don't deal with */
            return DefWindowProc (hwnd, message, wParam, lParam);
    }

    return 0;
}

VOID CALLBACK ExpTimerProc (HWND hwnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime) {
	HWND hwndTibia;
	DWORD dwPid;
	HANDLE hProc;
	//get tibia window
	hwndTibia = GetTibiaWnd(NULL);
	if (!hwndTibia) return;
	//extract current experience
	GetWindowThreadProcessId(hwndTibia, &dwPid);
	hProc = OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwPid);
	ReadProcessMemory(hProc, (LPCVOID)0x60EAC4, &dwExp[uExpIndex++], sizeof(dwExp[uExpIndex]), NULL);
	CloseHandle(hProc);
	uExpIndex %= EXP_HISTORY;
	//determine exp p.h.
	DWORD dwMinExp = 0, dwMaxExp = 0;
	float dwExpPerHour;
	unsigned int i;
	for (i = 0; i < EXP_HISTORY; i++) {
		if (dwExp[i] == 0) continue;
		if (dwExp[i] < dwMinExp || dwMinExp == 0) dwMinExp = dwExp[i];
		if (dwExp[i] > dwMaxExp) dwMaxExp = dwExp[i];
	}
	dwExpPerHour = (3600000 / EXP_GRANULARITY * (dwMaxExp - dwMinExp)) / EXP_HISTORY;
	//change tibia window title to match
	char szNewTitle[32];
	sprintf(szNewTitle, "Tibia %.1fk xp/hr", dwExpPerHour / 1000);
	SetWindowText(hwndTibia, szNewTitle);
	//MessageBox(NULL, szTmp, "Exp/h", 0);
	return;
}

BOOL IsTibiaWnd (HWND hwndCheck) {
	static const char szTibiaWndTitle[] = "Tibia";
	static const char szTibiaClassName[] = "TibiaClient";
	static const int nMaxCount = 100;
	char szString[nMaxCount];
	if (!GetWindowText(hwndCheck, szString, nMaxCount)) return FALSE;
	if (!strstr(szString, szTibiaWndTitle)) return FALSE;
	if (!GetClassName(hwndCheck, szString, nMaxCount)) return FALSE;
	if (strncmp(szString, szTibiaClassName, strlen(szTibiaClassName))) return FALSE;
	return TRUE;
}

HWND GetTibiaWnd (HWND hwndLast) {
	HWND hwndNext;
	if (!hwndLast) {
		hwndLast = GetDesktopWindow();
		hwndNext = GetWindow(hwndLast, GW_CHILD);
	} else {
		hwndNext = GetWindow(hwndLast, GW_HWNDNEXT);
	}
	while (hwndNext) {
		if (IsTibiaWnd(hwndNext)) break;
		hwndNext = GetWindow(hwndNext, GW_HWNDNEXT);
	}
	return hwndNext;
}
