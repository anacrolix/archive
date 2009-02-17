.486
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

.const
;The call to WS2_32.send
MEMORY_ADDRESS_Send_Pointer				equ 															00585614h

;The value in the mov ecx before the call to WS2_32.send
MEMORY_ADDRESS_Socket_Pointer			equ 															0074F180h

;The key used to encrypt/decrypt the packets
MEMORY_ADDRESS_XTEA_Key					equ MEMORY_ADDRESS_Socket_Pointer +	2Ch							;0074B1A0h

.code
DllEntry proc hInstance:HINSTANCE,reason:DWORD,reserved1:DWORD
	mov eax,TRUE
	ret
DllEntry Endp

XTEA PROC Encrypt:BYTE,ProcessID:DWORD,Key:DWORD,Packet:DWORD,XTEAPacket:DWORD,SafeArray:BYTE
	LOCAL Process 				:DWORD
	LOCAL XTEAkey[16]			:BYTE
	LOCAL XTEAkeyPointer		:DWORD
	LOCAL NumberOfBlocks		:WORD
	LOCAL PacketPointer			:DWORD
	LOCAL XTEAPacketPointer		:DWORD
	
	;Fix key
	.IF ProcessID!=NULL
		invoke OpenProcess,PROCESS_ALL_ACCESS,NULL,ProcessID
		.IF eax!=0
			mov Process,eax
			
			;Read the XTEA Key from Tibias memory
			invoke ReadProcessMemory,Process,MEMORY_ADDRESS_XTEA_Key,ADDR XTEAkey,16,NULL
			
			INVOKE CloseHandle,Process
			
			lea eax,XTEAkey
			mov XTEAkeyPointer,eax
			
		.ENDIF
		
	.ELSEIF Key!=NULL
		
		;Fix the pointer variables
		mov eax,Key
		.IF SafeArray!=NULL
			mov eax,DWORD PTR [eax]
			add eax,12
			mov eax,DWORD PTR [eax]
		.ENDIF
		mov XTEAkeyPointer,eax
		
	.ENDIF
	
	.IF ProcessID!=NULL || Key!=NULL
		
		;Fix pointers
		mov eax,Packet
		mov ecx,XTEAPacket
		.IF SafeArray!=NULL
			mov eax,DWORD PTR [eax]
			add eax,12
			mov eax,DWORD PTR [eax]
			mov ecx,DWORD PTR [ecx]
			add ecx,12
			mov ecx,DWORD PTR [ecx]
		.ENDIF
		mov PacketPointer,eax
		mov XTEAPacketPointer,ecx
		
		;Calculate how many blocks of 8-bytes that is going to be encrypted/decrypted
		movzx eax,WORD PTR [eax]
		.IF Encrypt!=FALSE
			
			add eax,2
			mov cx,8
			xor edx,edx
			div cx
			.IF edx!=0
				inc ax
			.ENDIF
			mov NumberOfBlocks,ax
			
			;Calculate the length of the encrypted packet and also write the header
			lea eax,[eax*8]
			mov ecx,XTEAPacketPointer
			mov WORD PTR [ecx],ax
			add XTEAPacketPointer,2
			
		.ELSEIF Encrypt==FALSE
			
			shr eax,3
			mov NumberOfBlocks,ax
			
			add PacketPointer,2
			
		.ENDIF
		
		movzx eax,Encrypt
		push eax
		
		;Main encryption loop
		.REPEAT
			mov edx,PacketPointer
			.IF BYTE PTR [esp]!=FALSE
				xor eax,eax
				mov ecx,DWORD PTR [edx]
				mov edx,DWORD PTR [edx+4]
			.ELSEIF BYTE PTR [esp]==FALSE
				mov eax,0C6EF3720h
				mov ecx,DWORD PTR [edx+4]
				mov edx,DWORD PTR [edx]
			.ENDIF
			push ebx
			push ebp
			push esi
			mov esi,XTEAkeyPointer
			push edi
			mov edi,32
			.REPEAT
				MOV EBX,EDX
				SHR EBX,5
				MOV EBP,EDX
				SHL EBP,4
				XOR EBX,EBP
				ADD EBX,EDX
				MOV EBP,EAX
				.IF BYTE PTR [esp+4*SIZEOF DWORD]==FALSE
					SHR	EBP,0Bh
				.ENDIF
				AND EBP,3
				MOV EBP,DWORD PTR DS:[ESI+EBP*4]
				ADD EBP,EAX
				XOR EBX,EBP
				.IF BYTE PTR [esp+4*SIZEOF DWORD]!=FALSE
					ADD ECX,EBX
					SUB EAX,61C88647h
				.ELSEIF BYTE PTR [esp+4*SIZEOF DWORD]==FALSE
					SUB	ECX,EBX
					ADD	EAX,61C88647h
				.ENDIF
				MOV EBX,ECX
				SHR EBX,5
				MOV EBP,ECX
				SHL EBP,4
				XOR EBX,EBP
				ADD EBX,ECX
				MOV EBP,EAX
				.IF BYTE PTR [esp+4*SIZEOF DWORD]!=FALSE
					SHR EBP,0Bh
				.ENDIF
				AND EBP,3
				MOV EBP,DWORD PTR DS:[ESI+EBP*4]
				ADD EBP,EAX
				XOR EBX,EBP
				.IF BYTE PTR [esp+4*SIZEOF DWORD]!=FALSE
					ADD EDX,EBX
				.ELSEIF BYTE PTR [esp+4*SIZEOF DWORD]==FALSE
					SUB	EDX,EBX
				.ENDIF
				DEC EDI
			.UNTIL edi==0
			pop edi
			pop esi
			pop ebp
			pop ebx
			mov eax,XTEAPacketPointer
			.IF BYTE PTR [esp]!=FALSE
				mov DWORD PTR [eax],ecx
				mov DWORD PTR [eax+4],edx
			.ELSEIF BYTE PTR [esp]==FALSE
				mov DWORD PTR [eax],edx
				mov DWORD PTR [eax+4],ecx
			.ENDIF
			add XTEAPacketPointer,8
			add PacketPointer,8
			dec NumberOfBlocks
		.UNTIL NumberOfBlocks==0
		
		add esp,4
		
		;Return the length of the packet
		mov ecx,XTEAPacket
		movzx eax,WORD PTR [ecx]
		.IF SafeArray!=NULL
			mov ecx,DWORD PTR [ecx]
			add ecx,12
			mov eax,DWORD PTR [ecx]
			movzx eax,WORD PTR [eax]
			add eax,2
			mov WORD PTR [ecx+4],ax
		.ENDIF
		add eax,2
		
	.ENDIF
	
	ret
XTEA endp

SendPacket PROC ProcessID:DWORD,Packet:DWORD,Encrypt:BYTE,SafeArray:BYTE
	LOCAL Process				:DWORD
	LOCAL Socket				:DWORD
	LOCAL PacketPointer			:DWORD
	LOCAL EncryptedPacketLength	:DWORD
	LOCAL PacketLength			:DWORD
	LOCAL TotalLength			:DWORD
	LOCAL AllocatedMemory		:DWORD
	LOCAL PacketInfo			:DWORD
	LOCAL RemoteThread			:DWORD
	
	jmp @SendPacket
	
@SendPacketThread:
	push 0
	push DWORD PTR DS:[ebx]
	add ebx,4
	push ebx
	mov eax,DWORD PTR DS:[MEMORY_ADDRESS_Socket_Pointer]
	push DWORD PTR DS:[eax+4]
	call DWORD PTR DS:[MEMORY_ADDRESS_Send_Pointer]
	retn
	
@SendPacket:
	INVOKE OpenProcess,PROCESS_ALL_ACCESS,NULL,ProcessID
	.IF eax!=0
		mov Process,eax
		mov Socket,0
		INVOKE ReadProcessMemory,Process,MEMORY_ADDRESS_Socket_Pointer,ADDR Socket,4,NULL
		.IF Socket!=0
			mov eax,Packet
			.IF SafeArray!=NULL
				mov eax,DWORD PTR [eax]
				add eax,12
				mov eax,DWORD PTR [eax]
			.ENDIF
			mov PacketPointer,eax
			
			.IF Encrypt!=NULL
				
				;Make space for the encrypted packet
				mov eax,PacketPointer
				movzx eax,WORD PTR [eax]
				add eax,2
				mov cx,8
				xor edx,edx
				div cx
				.IF edx!=0
					inc ax
				.ENDIF
				lea eax,[eax*8+4]
				mov EncryptedPacketLength,eax
				sub esp,eax
				mov eax,esp
				
				INVOKE XTEA,TRUE,ProcessID,NULL,PacketPointer,eax,NULL
				
				mov PacketPointer,esp
				
			.ENDIF
			
			mov eax,PacketPointer
			movzx eax,WORD PTR [eax]
			add eax,2
			mov PacketLength,eax
			add eax,((OFFSET @SendPacket - OFFSET @SendPacketThread) + SIZEOF DWORD)
			mov TotalLength,eax
			INVOKE VirtualAllocEx,Process,NULL,TotalLength,MEM_COMMIT+MEM_RESERVE,PAGE_EXECUTE_READWRITE
			mov AllocatedMemory,eax
			mov PacketInfo,eax
			INVOKE WriteProcessMemory,Process,AllocatedMemory,OFFSET @SendPacketThread,(OFFSET @SendPacket - OFFSET @SendPacketThread),NULL
			add PacketInfo,(OFFSET @SendPacket - OFFSET @SendPacketThread)
			INVOKE WriteProcessMemory,Process,PacketInfo,ADDR PacketLength,4,NULL
			add PacketInfo,SIZEOF DWORD
			INVOKE WriteProcessMemory,Process,PacketInfo,PacketPointer,PacketLength,NULL
			.IF Encrypt!=NULL
				add esp,EncryptedPacketLength
			.ENDIF
			sub PacketInfo,SIZEOF DWORD
			INVOKE CreateRemoteThread,Process,NULL,NULL,AllocatedMemory,PacketInfo,NULL,NULL
			mov RemoteThread,eax
			INVOKE WaitForSingleObject,RemoteThread,INFINITE
			INVOKE CloseHandle,RemoteThread
			INVOKE VirtualFreeEx,Process,AllocatedMemory,0,MEM_RELEASE
		.ENDIF
		INVOKE CloseHandle,Process
	.ENDIF
	ret
SendPacket endp

End DllEntry