#include <stdio.h>
#include <string.h>

#define INPUT_MAX 2000
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

void filter(char *s) {
	char output[strlen(s)];
	/*uint i = 0, j = 0;
	while (s[i] != '\0') {
		if (s[i] != ' ') output[j++] = s[i];
		i++;
	}
	output[j] = '\0';*/
	sprintf(output, "%s", s);
	strcpy(s, output);
	return;
}

void hexToValues(unsigned char *s, int len) {
	unsigned char v[len/2];
	int i=0;
	uint x;
	while (i < len) {
		sscanf(&s[i*2],"%2x",&x);
		//printf("%u",x);
		v[i] = x;
		//printf(" %x\n",v[i]);
		i++;
	}
	//v[i] = '\0';
	for (i=0;i<len;i++) {
		s[i]=v[i];
	}
	return;
}

int main(int argc, char **argv) {
	unsigned char input[INPUT_MAX];
	int i, len;
	//get input
	strcpy(input,argv[1]);
	for (i=2; i < argc; i++) strcat(input, argv[i]);
	//printf("strlen(input)=%d\n",strlen(input));
	len = strlen(input)/2;
	//printf("input:\t%s\n", input);
	hexToValues(input,len);
	//for (i=0;i<len;i++) printf("%2x ",input[i]);
	//printf("\n");
	for (i=16;i<len;i+=8) decipher(&input[i],input);
	//print key
	printf("\nKEY\t");
	for (i=0;i<16;i++) printf("%2x ",input[i]);
	printf("\n\nPACKET\t");
	for (i=16;i<len;i++) printf("%2x ",input[i]);
	//sscanf(input,"%2x",&c);
	//printf("first hex val=%u",c);
	return 0;
}