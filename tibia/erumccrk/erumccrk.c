#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OPCODE_SEPARATION 10
#define OPCODE_PUSH_DWORD 0x68
#define OPCODE_JLE_NEAR 0x7e
#define OPCODE_JMP_NEAR 0xeb

#define debug printf

const char* TIBIA_MC_WARNING = "A Tibia client is already running!";
const char* TIBIA_FILE_NAME = "Tibia.exe";

void err_quit (char *quitstr) {
	printf(quitstr);
	putchar ('\n');
	system("pause");
	exit (EXIT_SUCCESS);
}

void err_sys (char *errstr) {
	perror (errstr);
	putchar ('\n');
	system("pause");
	exit (EXIT_FAILURE);
}

int main (int argc, char **argv) {

	// open client file
	FILE *f =	fopen(TIBIA_FILE_NAME, "rb+");
	if (f == NULL) err_sys("Open client file");

	// determine file size
	if (fseek(f, 0, SEEK_END)) err_sys("Seek end of file");
	size_t size = ftell(f);
	debug("Client file size is %u bytes\n", size);

	// copy file to buffer
	unsigned char *buffer = (char *) malloc (size);
	if (buffer == NULL) err_sys("Allocate buffer for file");
	rewind (f);
	if (size != fread(buffer, 1, size, f)) err_sys("Read file to buffer");

	// search for string
	size_t i = 0, len = strlen(TIBIA_MC_WARNING);
	while (i < size - len) {
		if (strncmp(&buffer[i], TIBIA_MC_WARNING, len) == 0) break;
		i++;
	}
	if (i >= size) err_quit("Tibia MC warning string not found");
	debug("Found MC warning string with address %08x\n", i);
	char *offset = (char *)i + 0x00400000;

	// find jle near opcode
	i = OPCODE_SEPARATION;
	char *posJmpCode;
	while (i < size) {
		if (*(char **)&buffer[i] == offset && buffer[i-1] == OPCODE_PUSH_DWORD) {
			posJmpCode = (char *)i - OPCODE_SEPARATION;
			break;
		}
		i++;
	}

	// change the jump code
	if (posJmpCode == NULL) err_quit("Unable to locate push opcode");
	if (buffer[(int)posJmpCode] == OPCODE_JMP_NEAR) err_quit("Client already supports MC");
	if (buffer[(int)posJmpCode] != OPCODE_JLE_NEAR) {
		printf(" %02x ", buffer[(int)posJmpCode]);
		err_quit("Unexpected opcode found");
	}
	fseek (f, (int)posJmpCode, SEEK_SET);
	fputc (OPCODE_JMP_NEAR, f);
	printf ("Client was patched\n");
	free (buffer);
	fclose (f);
	system("pause");
	return 0;
}
