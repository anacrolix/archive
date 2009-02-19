.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include Tibia Online.inc

.data

szUserName db 'msie', 0
szUrl db 'http://www.tibia.com/statistics/?subtopic=whoisonline&world=Dolera', 0
szVipUrl db 'http://nya.madpage.com/vips2.txt', 0
szAddUrl db 'http://nya.madpage.com/vips2.php?nip=%s&pl=%d;%s&desc=%s', 0
szCharString db 'HREF="http://www.tibia.com/community/?subtopic=character&name='

SaveFilePath        db 260 dup (?)

ptrVipFile dd ?

szDescription db 'Player Description', 0

szEnemies db 'Enemies ', 0
szAllies db 'Allies ', 0
szNeutral db 'Neutral ', 0
szEnd db ' ', 0
szSpace db ' - ', 0
szSpaces db '   ', 0

iEnemies dd ?
iAllies dd ?
iNeutral dd ?

cEnemies dd ?
cAllies dd ?
cNeutral dd ?

ptrPrasedVipFile dd ?

VIPENTRY struct
	szName db 34 dup (?)
	szDescription db 256 dup (?)
VIPENTRY ends

dwTimer dd 0

.data?

cText dd ?
hBrush dd ?
hWnd dd ?
hInternet dd ?
hUrlObject dd ?
hHeapBuffer dd ?
dwBufferOffset dd ?
dbZero db 14 dup (?)

hTimeFunction dd ?

dwLastTime SYSTEMTIME {}

TopList dd 400 dup (?)
NIP db 32 dup (?)

bAlliesId dd ?
bNeutralId dd ?
bEnemiesId dd ?

; Database

ptrDatabase dd ?

dbPlayer struct
	PlayerName db 32 dup (?)
	TimeOnline db 14 dup (?)
dbPlayer ends


AddNameToDatabase PROTO :DWORD,:DWORD
MemCpy PROTO dest:DWORD, src:DWORD, len:DWORD

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################


AddVipProc PROTO :DWORD,:DWORD,:DWORD,:DWORD

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	LOCAL ID:DWORD
	LOCAL pos:RECT
	LOCAL buffer[256]:BYTE
	LOCAL Len:DWORD

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		push hWin
		pop hWnd
		
		invoke GetModuleFileName, hInstance, addr SaveFilePath, 260
		lea ecx, [SaveFilePath]
		add eax, ecx
		
		.while byte ptr [eax] != '\' && eax > ecx
			dec eax
		.endw
		
		mov byte ptr [eax+1], 0
		
		invoke VirtualAlloc, NULL, 2024*1024, MEM_COMMIT, PAGE_READWRITE
		mov ptrVipFile, eax
		
		invoke VirtualAlloc, NULL, sizeof VIPENTRY*1024*8 + 2*sizeof VIPENTRY*1024, MEM_COMMIT, PAGE_READWRITE
		mov ptrPrasedVipFile, eax
		
		; call LoadFiles
		
		invoke InternetOpen, addr szUserName, INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, NULL
		mov hInternet, eax
		
		.if eax
			invoke GetProcessHeap
			invoke HeapAlloc, eax, NULL, 2048*1024
			mov hHeapBuffer, eax
			
			invoke SetTimer, hWnd, NULL, 100, NULL
		.endif
	.elseif eax==WM_COMMAND
		mov	eax,wParam
		shr eax, 16
		
		.if eax==LBN_DBLCLK
			invoke SendDlgItemMessage, hWnd, 1001, LB_GETCURSEL, NULL, NULL
			.if eax != LB_ERR
				invoke SendDlgItemMessage, hWnd, 1001, LB_GETITEMDATA, eax, 0
			.else
				mov eax, 0
			.endif
			
			invoke CreateDialogParam, hInstance, 1000, hWnd, addr AddVipProc, eax
		.endif
    .elseif eax==WM_MEASUREITEM
		mov eax, lParam
		mov [eax].MEASUREITEMSTRUCT.itemHeight, 13
		
		mov eax, TRUE
		ret
	.elseif eax==WM_DRAWITEM
		invoke SendDlgItemMessage, hWnd, 1001, LB_GETCOUNT, 0, 0
		
		.if !eax
			ret
		.endif
		
		mov ebx, lParam
		invoke SendDlgItemMessage, hWnd, 1001, LB_GETTEXTLEN, [ebx].DRAWITEMSTRUCT.itemID, 0
		mov Len, eax
		invoke SendDlgItemMessage, hWnd, 1001, LB_GETTEXT, [ebx].DRAWITEMSTRUCT.itemID, addr buffer
		
		mov ebx, lParam
		
		mov ecx, [ebx].DRAWITEMSTRUCT.itemID
		.if ecx < iAllies
			mov cText, 00000FFh
		.elseif ecx < iNeutral
			mov cText, 0FF0000h
		.else
			mov cText, 0009900h
		.endif
		
		invoke SetTextColor, [ebx].DRAWITEMSTRUCT.hdc, cText
		
		mov ecx, [ebx].DRAWITEMSTRUCT.itemID
		.if ecx == iEnemies || ecx == iAllies || ecx == iNeutral
			invoke DrawText, [ebx].DRAWITEMSTRUCT.hdc, addr buffer, Len, addr [ebx].DRAWITEMSTRUCT.rcItem, DT_LEFT
		.else
			invoke DrawText, [ebx].DRAWITEMSTRUCT.hdc, addr buffer, Len, addr [ebx].DRAWITEMSTRUCT.rcItem, DT_LEFT
		.endif
	.elseif eax==WM_TIMER
		.if dwTimer==0
			call ContextProc
			mov dwTimer, 1*60*1000
		.else
			sub dwTimer, 100
		.endif
	.elseif eax==WM_SIZE
		invoke GetClientRect, hWnd, addr pos
		invoke GetDlgItem, hWnd, 1001
		invoke MoveWindow, eax, 0, 0, pos.right, pos.bottom, TRUE
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

AddVipProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	LOCAL ID:DWORD
	LOCAL pos:RECT
	LOCAL buff[32]:BYTE
	LOCAL buffer512[512]:BYTE
	LOCAL descr[256]:BYTE
	LOCAL dwGroup:DWORD

	mov	eax,uMsg
	.if eax==WM_INITDIALOG
		mov ebx, lParam
		.if ebx
			invoke SendDlgItemMessage, hWin, 1002, WM_SETTEXT, 0, addr [ebx+2]
			movzx ecx, byte ptr [ebx]
			sub ecx, '1'
			invoke SendDlgItemMessage, hWin, 1010, LB_SETCURSEL, ecx, 0
			add ebx, VIPENTRY.szDescription
			invoke SendDlgItemMessage, hWin, 1003, WM_SETTEXT, 0, ebx
		.endif
		
		invoke SendDlgItemMessage, hWin, 1008, WM_SETTEXT, 0, addr NIP
		
		invoke SendDlgItemMessage, hWin, 1010, LB_ADDSTRING, 0, addr szEnemies
		invoke SendDlgItemMessage, hWin, 1010, LB_ADDSTRING, 0, addr szAllies
		invoke SendDlgItemMessage, hWin, 1010, LB_ADDSTRING, 0, addr szNeutral
		
		invoke SendDlgItemMessage, hWin, 1010, LB_SETITEMHEIGHT, 0, 17
	.elseif eax==WM_COMMAND
		mov	eax,wParam
		.if ax == 1002
			invoke SendDlgItemMessage, hWin, 1002, WM_GETTEXT, 32, addr buff
			
			mov ebx, ptrPrasedVipFile
		@@:
			.if byte ptr [ebx]
				invoke lstrcmpi, addr [ebx+2], addr buff
				.if eax == 0
					movzx ecx, byte ptr [ebx]
					sub ecx, '1'
					mov dwGroup, ecx
					
					add ebx, VIPENTRY.szDescription
					mov edi, ebx
					
					push ebx
				hahu:
					.if byte ptr [ebx]
						.if word ptr [ebx]=="'\"
							mov byte ptr [edi], "'"
							inc ebx
						.else
							mov cl, byte ptr [ebx]
							mov byte ptr [edi], cl
						.endif
						
						inc ebx
						inc edi
						jmp hahu
					.else
						mov byte ptr [edi], 0
					.endif
					
					pop ebx
					
					invoke SendDlgItemMessage, hWin, 1003, WM_SETTEXT, 0, ebx
					invoke SendDlgItemMessage, hWin, 1010, LB_SETCURSEL, dwGroup, 0
					
					ret
				.endif
				add ebx, sizeof VIPENTRY
				jmp @B
			.endif
		.elseif ax == 1005
			invoke SendDlgItemMessage, hWin, 1002, WM_GETTEXT, 32, addr buff
			invoke SendDlgItemMessage, hWin, 1003, WM_GETTEXT, 256, addr descr
			
			lea ebx, [descr]
		@@:
			.if byte ptr [ebx]
				.if word ptr [ebx] == "//"
					lea ecx, [descr]
					.if ebx > ecx && byte ptr [ebx-1] == ' '
						mov byte ptr [ebx-1], 0
					.else
						mov byte ptr [ebx], 0
					.endif
				.endif
				
				inc ebx
				jmp @B
			.endif
			
			invoke SendDlgItemMessage, hWin, 1008, WM_GETTEXT, 32, addr NIP
			invoke SendDlgItemMessage, hWin, 1010, LB_GETCURSEL, 0, 0
			
			.if eax!=LB_ERR
				lea ebx, [eax+1]
				invoke wsprintf, addr buffer512, addr szAddUrl, addr NIP, ebx, addr buff, addr descr
				
				invoke InternetOpenUrl, hInternet, addr buffer512, NULL, NULL, INTERNET_FLAG_RELOAD, NULL
				invoke InternetCloseHandle, hUrlObject
				
				mov dwTimer, 100
			.endif
			
			invoke EndDialog, hWin,0
			
			ret
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE

	ret
	
AddVipProc endp

ContextProc proc

	LOCAL nob:DWORD
	LOCAL totalsleep:DWORD
	
	; PrintDword eax

	invoke SendDlgItemMessage, hWnd, 1001, LB_RESETCONTENT, NULL, NULL

	; GetVipFile

	invoke InternetOpenUrl, hInternet, addr szVipUrl, NULL, NULL, INTERNET_FLAG_RELOAD, NULL
	mov hUrlObject, eax
	
	mov dwBufferOffset, 0
	mov totalsleep, 0
	
@@:
	mov edx, ptrVipFile
	add edx, dwBufferOffset
	
	invoke InternetReadFile, hUrlObject, edx, 1024*1024, addr nob
	
	mov ebx, nob
	
	.if eax && ebx==0
		mov edx, hHeapBuffer
		add edx, dwBufferOffset
		
		mov byte ptr [edx], 0
		
		call ParseVipFile
	.else
		add dwBufferOffset, ebx
		
		invoke Sleep, 100
		add totalsleep, 100
		
		.if totalsleep < 10000
			jmp @B
		.endif
	.endif

	mov eax, ptrPrasedVipFile
	add eax, sizeof VIPENTRY*1024*8
	lea ebx, [eax+sizeof VIPENTRY*1024]
	
	invoke MemCpy, ebx, eax, sizeof VIPENTRY*1024
	
	mov byte ptr [eax], 0

	invoke InternetCloseHandle, hUrlObject

	; Get Tibia Online List

	invoke InternetOpenUrl, hInternet, addr szUrl, NULL, NULL, INTERNET_FLAG_RELOAD, NULL
	mov hUrlObject, eax
	
	mov dwBufferOffset, 0
	mov totalsleep, 0
	
@@:
	mov edx, hHeapBuffer
	add edx, dwBufferOffset
	
	invoke InternetReadFile, hUrlObject, edx, 1024*1024, addr nob
	
	mov ebx, nob
	
	.if eax && ebx==0
		mov edx, hHeapBuffer
		add edx, dwBufferOffset
		
		mov byte ptr [edx], 0
		
		call SearchBuffer
		
		mov eax, ptrPrasedVipFile
		add eax, sizeof VIPENTRY*1024*8
		lea ebx, [eax+sizeof VIPENTRY*1024]
		
		invoke lstrcmp, eax, ebx
		.if eax != 0
			invoke MessageBeep, 0FFFFFFFFh	
		.endif
	.else
		add dwBufferOffset, ebx
		
		invoke Sleep, 100
		add totalsleep, 100
		
		.if totalsleep < 10000
			jmp @B
		.endif
	.endif
	
	invoke InternetCloseHandle, hUrlObject
	
	ret

ContextProc endp

ZeroMemory proc address:DWORD, lenght:DWORD
	
	xor al, al
	mov edi, address
	mov ecx, lenght
	
	rep stosb
	
	ret

ZeroMemory endp

;.data
;szVips db 'vips.txt', 0
;
;.code
;LoadFiles proc
;	
;	LOCAL hFileRead:DWORD
;	LOCAL hMapFile:DWORD
;	LOCAL dwHigh:DWORD
;	LOCAL FileNameBuffer[300]:BYTE
;
;	.if eax
;		invoke lstrcpy, addr FileNameBuffer, addr SaveFilePath
;		invoke lstrcat, addr FileNameBuffer, addr szVips
;		
;		invoke CreateFile, addr FileNameBuffer, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, NULL
;		mov hFileRead, eax
;		
;		.if ( eax != INVALID_HANDLE_VALUE )
;			invoke CreateFileMapping, hFileRead, NULL, PAGE_READONLY, 0, 0, NULL
;			mov  hMapFile, eax
;			
;			invoke MapViewOfFile, hMapFile, FILE_MAP_READ, 0, 0, 0 
;			
;			push eax
;			invoke GetFileSize, hFileRead, addr dwHigh
;			pop ebx
;			
;			mov edi, ptrVipFile
;			mov esi, ebx
;			
;			mov ecx, eax
;			
;			rep movsb
;			
;			invoke UnmapViewOfFile, ebx
;			
;			invoke CloseHandle, hMapFile
;			invoke CloseHandle, hFileRead
;		.endif
;		
;		call ParseVipFile
;	.endif
;
;	ret
;
;LoadFiles endp

ParseVipFile proc
	
	LOCAL count:DWORD
	LOCAL bDesc:BYTE
	
	mov count, 0	
	mov ebx, ptrVipFile

next:
	mov eax, count
	imul eax, sizeof VIPENTRY
	add eax, ptrPrasedVipFile
	
	mov bDesc, 0
	
	.if byte ptr [ebx]
	@@:
		mov cl, byte ptr [ebx] 
		.if cl == ':' && !bDesc
			mov bDesc, TRUE
			mov byte ptr [eax], 0
			
			mov eax, count
			imul eax, sizeof VIPENTRY
			add eax, ptrPrasedVipFile
			add eax, VIPENTRY.szDescription
			
			inc ebx
			jmp @B
		.elseif cl == 0Ah
			mov byte ptr [eax], 0
			inc count
			inc ebx
			jmp next
		.elseif cl == 0
			mov byte ptr [eax], 0
		.else
			mov byte ptr [eax], cl
			
			inc eax
			inc ebx
			jmp @B
		.endif
	.endif
	
	ret

ParseVipFile endp

MemCpy proc dest:DWORD, src:DWORD, len:DWORD

	mov ecx, len
	mov esi, src
	mov edi, dest
	
	rep movsb

	ret

MemCpy endp


SearchBuffer proc

	LOCAL PlayerName[64]:BYTE
	LOCAL PlayerLevel[32]:BYTE

	invoke SendDlgItemMessage, hWnd, 1001, LB_ADDSTRING, 0, addr szEnemies
	invoke SendDlgItemMessage, hWnd, 1001, LB_ADDSTRING, 0, addr szAllies
	invoke SendDlgItemMessage, hWnd, 1001, LB_ADDSTRING, 0, addr szNeutral

	mov iEnemies, 0
	mov iAllies, 1
	mov iNeutral, 2

	mov cEnemies, 0
	mov cAllies, 0
	mov cNeutral, 0

	mov eax, hHeapBuffer
	
@@:
	mov ecx, offset szCharString

	mov dl, byte ptr [ecx]
	mov bl, byte ptr [eax]

	.while bl != dl
		.if !bl
			jmp Endy
		.endif
		
		inc eax
		mov bl, byte ptr [eax] 
	.endw

	.while bl==dl
		.if ecx == offset szCharString + sizeof szCharString - 1
			inc eax
			
			xor ecx, ecx
			.while byte ptr [eax] != '"'
				mov bl, byte ptr [eax]
				.if bl == '+'
					mov byte ptr [PlayerName+ecx], 20h
				.elseif bl == '%'
					inc eax
					mov bl, byte ptr [eax]
					sub bl, '0'
					shl bl, 4
					inc eax
					add bl, byte ptr [eax]
					sub bl, '0'
					mov byte ptr [PlayerName+ecx], bl
				.else
					mov byte ptr [PlayerName+ecx], bl
				.endif
				
				inc eax
				inc ecx
			.endw
			
			mov byte ptr [PlayerName+ecx], 0
			
			push eax
			push ecx
			
			.while byte ptr [eax]!= '<'
				inc eax
			.endw
			
			add eax, 23
			xor ecx, ecx
			
			.while byte ptr [eax] != '<'
				mov bl, byte ptr [eax]
				mov byte ptr [PlayerLevel+ecx], bl
				inc ecx
				inc eax
			.endw
			
			mov byte ptr [PlayerLevel+ecx], 0
			
			invoke AddNameToDatabase, addr PlayerName, addr PlayerLevel
			pop ecx
			pop eax
			
			;pusha
			;invoke OutputDebugString, addr PlayerName
			;popa
			
			.break
		.endif
		
		inc eax
		inc ecx
		
		mov dl, byte ptr [ecx]
		mov bl, byte ptr [eax]
	.endw

	jmp @B

Endy:

	mov ebx, cEnemies
	mov edx, iEnemies
	mov ecx, offset szEnemies
	
	call SetTypeCount

	mov ebx, cAllies
	mov edx, iAllies
	mov ecx, offset szAllies
	
	call SetTypeCount

	mov ebx, cNeutral
	mov edx, iNeutral
	mov ecx, offset szNeutral
	
	call SetTypeCount

	ret
	
SearchBuffer endp

AddNameToDatabase proc ptrName:DWORD, ptrPlayerLevel:DWORD

	LOCAL SpaceFound:DWORD
	LOCAL buf64[64]:BYTE
	LOCAL buf128[128]:BYTE

	mov ebx, ptrPrasedVipFile
@@:
	.if byte ptr [ebx]
		lea edx, [ebx+2]
		invoke lstrcmpi, edx, ptrName
		.if eax == 0
			movzx ecx, byte ptr [ebx]
			
			sub ecx, '1'
			shl ecx, 2
			
			mov eax, dword ptr [iEnemies+ecx]
			add eax, dword ptr [cEnemies+ecx]
			inc dword ptr [cEnemies+ecx]
			
			.if ecx == 0
				inc iAllies
				inc iNeutral
			.elseif ecx == 4
				inc iNeutral
			.endif
			
			inc eax
			
			push eax
			invoke lstrcpy, addr buf128, addr szSpaces
			invoke lstrcat, addr buf128, ptrName
			invoke lstrcat, addr buf128, addr szSpace
			invoke lstrcat, addr buf128, ptrPlayerLevel
			pop ecx
			
			invoke SendDlgItemMessage, hWnd, 1001, LB_INSERTSTRING, ecx, addr buf128
			invoke SendDlgItemMessage, hWnd, 1001, LB_SETITEMDATA, eax, ebx
			
			mov eax, ptrPrasedVipFile
			add eax, sizeof VIPENTRY*1024*8
			
			invoke lstrcat, eax, ptrName
			
			ret
		.endif
		
		add ebx, sizeof VIPENTRY
		jmp @B
	.endif

	ret
	
AddNameToDatabase endp

SetTypeCount proc

	LOCAL buffer[255]:BYTE
	LOCAL buf32[32]:BYTE
	
	; ebx = count
	; edx = index
	; ecx = string
	
	push edx
	
	invoke lstrcpy, addr buffer, ecx
	invoke dwtoa, ebx, addr buf32
	invoke lstrcat, addr buffer, addr buf32
	invoke lstrcat, addr buffer, addr szEnd
	
	pop edx
	push edx
	invoke SendDlgItemMessage, hWnd, 1001, LB_DELETESTRING, edx, 0
	pop edx
	invoke SendDlgItemMessage, hWnd, 1001, LB_INSERTSTRING, edx, addr buffer
	
	ret

SetTypeCount endp

end start
