#include <stdio.h>
#include <ctype.h>
#include <string.h>

const int INPUT_LEN = 1;
const int FIB_DEPTH = 15;

void printAscii(FILE*);
void printFibonacci(FILE*, int);

int main(void) {
	char s[INPUT_LEN];
	int i;
	FILE *fp;
	do {
		printf("What function do you wish to output?\n");
		printf("\n");
		printf("\t1. Ascii table\n");
		printf("\t2. Fibonacci\n");
		printf("\tQ. Quit\n\n> ");

		scanf("%1s", s);
		//printf("The first character was: %s", s);
		for (i=0;i<strlen(s);i++) tolower(s[i]);

		if (strncmp(s,"1",1) == 0) {
			fp=fopen("ascii.txt","w");
			printAscii(fp);
			fclose(fp);
		} else if (strncmp(s,"2",1) == 0) {
			fp=fopen("fibonacci.txt","w");
			printFibonacci(fp,FIB_DEPTH);
			fclose(fp);
		} else return 0;
		printf("\n");
	} while (1);
}

void printAscii(FILE *fp) {
	int i;
	fprintf(fp,"Dec\tHex\tAscii\tDec\tHex\tAscii\n");
	for (i=0;i<128;i++) fprintf(fp, "%d\t%x\t%c\t%d\t%x\t%c\n",i,i,(i==9||i==10)?32:i,i+128,i+128,(i+128==9||i+128==10)?32:i+128);
	return;
}

void printFibonacci(FILE *fp, int depth) {
	unsigned int i,first=0,second=1,sum;
	fprintf(fp,"Depth\tValue\n");
	for (i=0;i<depth;i++) {
		sum=first+second;
		fprintf(fp,"%d.\t%d\n",i+1, sum);
		first=second;
		second=sum;
	}
	return;
}

