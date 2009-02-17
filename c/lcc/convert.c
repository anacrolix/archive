#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define INPUT_MAX 3000
typedef unsigned int uint;

void decipher(unsigned long* v, unsigned long* k) {
    unsigned long v0=v[0], v1=v[1], i;
    unsigned long sum=0xC6EF3720, delta=0x9E3779B9;
    for(i=0; i<32; i++) {
        v1 -= ((v0 << 4 ^ v0 >> 5) + v0) ^ (sum + k[sum>>11 & 3]);
        sum -= delta;
        v0 -= ((v1 << 4 ^ v1 >> 5) + v1) ^ (sum + k[sum & 3]);
    }
    v[0]=v0; v[1]=v1;
}

void decipherString(char *s, void* key) {
	if (strlen(s) % 4 != 0) {
		strncat(s, "   ", strlen(s) % 4);
	}
	for (uint i = 0; i < strlen(s); i+=4) {
		decipher((unsigned long*)&s[i], (unsigned long*)key);
	}
	return;
}

void strnfltc(char *s, uint len, char c) {
	char output[len];
	uint i = 0, j = 0;
	while (i < len) {
		if (s[i] != c) output[j++] = s[i];
		i++;
	}
	output[j++] = '\0';
	for (i = 0; i < j; i++) s[i] = output[i];
	return;
}

void hexToValues(unsigned char *s, int len) {
	int i=0;
	uint x;
	while (i < len) {
		sscanf(&s[i*2],"%2x",&x);
		//printf("%u",x);
		s[i] = (unsigned char)x;
		//printf(" %x\n",s[i]);
		i++;
	}
	//v[i] = '\0';
	/*for (i=0;i<len;i++) {
		s[i]=v[i];
	}*/
	return;
}

int main(int argc, char **argv) {
	unsigned char input[INPUT_MAX], c;
	int i, len;
	uint v;
	//uint v;
	//get input
	i=0;
	c = getchar();
	while (c != EOF && c != '\n' && i < INPUT_MAX - 1) {
		input[i] = c;
		i++;
		c = getchar();
	}
	input[i] = '\0';
	fflush(stdin);
	strnfltc(input, strlen(input), ' ');
	printf("Delimited:\n%s\n\n",input);
	printf("strlen = %d\n\n",strlen(input));
	len = strlen(input) / 2;
	printf("len = %d\n\n",len);
	hexToValues(input, strlen(input));
	for (i=0;i<len;i++) {
		c = input[i];
		printf("%d ",(uint)c);
	}
	printf("\n\n");
	for (i=0;i<len;i++) {
		printf("%d",i);
		printf("\t%#x\t%d", input[i],input[i]);
		if (isalpha(input[i])) printf("\t%c",input[i]);
		printf("\n");
	}
	/*
	strcpy(input,argv[1]);
	for (i=2; i < argc; i++) strcat(input, argv[i]);
	printf("strlen(input)=%d\n",strlen(input));
	len = strlen(input)/2;
	printf("input:\t%s\n", input);
	hexToValues(input,len);
	for (i=0;i<len;i++) printf("%2x ",input[i]);
	printf("\n");
	decipher(&input[16],input);
	for (i=0;i<len;i++) printf("%2x ",input[i]);
	printf("\n");
	//sscanf(input,"%2x",&c);
	//printf("first hex val=%u",c);*/
	return 0;
}