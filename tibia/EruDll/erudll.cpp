#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

void EncipherXteaBlock(unsigned long* v, unsigned long* k) {
    unsigned long v0=v[0], v1=v[1], i;
    unsigned long sum=0, delta=0x9E3779B9;
    for(i=0; i<32; i++) {
        v0 += ((v1 << 4 ^ v1 >> 5) + v1) ^ (sum + k[sum & 3]);
        sum += delta;
        v1 += ((v0 << 4 ^ v0 >> 5) + v0) ^ (sum + k[sum>>11 & 3]);
    }
    v[0]=v0; v[1]=v1;
};

void DecipherXteaBlock(unsigned long* v, unsigned long* k) {
    unsigned long v0=v[0], v1=v[1], i;
    unsigned long sum=0xC6EF3720, delta=0x9E3779B9;
    for(i=0; i<32; i++) {
        v1 -= ((v0 << 4 ^ v0 >> 5) + v0) ^ (sum + k[sum>>11 & 3]);
        sum -= delta;
        v0 -= ((v1 << 4 ^ v1 >> 5) + v1) ^ (sum + k[sum & 3]);
    }
    v[0]=v0; v[1]=v1;
};

int _stdcall EncipherXteaPacket(unsigned char *b, unsigned int len, unsigned char *k) {
	unsigned int i;
	if ((len - 2) % 8 != 0) return -1;
	for (i = 2; i < len; i += 8) EncipherXteaBlock((unsigned long*)&b[i], (unsigned long*)k);
	return 0;
};

int _stdcall DecipherXteaPacket(unsigned char *b, unsigned int len, unsigned char *k) {
	unsigned int i;
	if ((len - 2) % 8 != 0) return -1;
	for (i = 2; i < len; i += 8) DecipherXteaBlock((unsigned long*)&b[i], (unsigned long*)k);
	return 0;
};

/*

/*
int _stdcall ReadMemory(HANDLE processHandle, DWORD address, DWORD length, long* val) {
		ReadProcessMemory(processHandle, (LPVOID) address, val, length, 0);
	//}
  return 0;
};

int _stdcall WriteMemory(HANDLE processHandle, DWORD address, DWORD length, long val) {
  WriteProcessMemory(processHandle, (LPVOID) address, &val, length, 0);
  return 0;
};

/*
int _stdcall ReadMemoryString(HANDLE processHandle, DWORD address, DWORD length, char* str) {
	/*
	if (address >= ADR_CHAR_MEM_START && address + length < ADR_CHAR_MEM_END) {
		strncpy(str, &charMem[address - ADR_CHAR_MEM_START], length);
		return 1;
	} else {
		ReadProcessMemory(processHandle, (LPVOID) address, str, length, 0);
	//}
	return 0;
};

int _stdcall WriteMemoryString(HANDLE processHandle, DWORD address, DWORD length, char *str) {
	WriteProcessMemory(processHandle, (LPVOID) address, str, length, 0);
	return 0;
};

*/