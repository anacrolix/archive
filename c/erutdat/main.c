#include <stdio.h>
#include <stdlib.h>

const char g_szDatFile[] = "tibia.dat";

void printTileData(FILE *fpDatFile) {
	long lSize;
	fseek(fpDatFile
	int byte;
	unsigned int idCount = 0, skip;
	fseek(fpDatFile, 0xC, SEEK_SET);
	while((byte = fgetc(fpDatFile)) >= 0 && (byte != 0xFF) {

	return;
}

int main(int argc, char *argv[])
{
	char *pszDatFile = NULL;
	if (argc == 2) {
		pszDatFile = argv[1];
	} else {
		pszDatFile = g_szDatFile;
	}
	printf("%s\n", pszDatFile);
	FILE *fp = fopen(pszDatFile, "r");
	if (fp) {
		printf("opened file successfully!\n");
		printTileData(fp);
		fclose(fp);
	} else {
		printf("file could not be opened!\n");
	}
	system("PAUSE");
  	return 0;
}
