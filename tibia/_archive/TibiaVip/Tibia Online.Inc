include kernel32.inc
includelib kernel32.lib

include windows.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include wininet.inc
include debug.inc
include masm32.inc
include gdi32.inc

includelib gdi32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib wininet.lib
includelib debug.lib
includelib masm32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
ZeroMemory		PROTO	:DWORD,:DWORD

.const

IDD_DIALOG1			equ 101

;#########################################################################

.data?

hInstance			dd ?

;#########################################################################

;5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"$L" /OUT:"$5",3,4
