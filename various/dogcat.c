#include <stdio.h>
#include <stdlib.h>
#include <string.h>

inline void *malloc0(size_t size) { return calloc(size, 1); }

int count(char const haystack[], char const needle[])
{
	int rv = 0;
	while (NULL != (haystack = strstr(haystack, needle))) {
		rv++;
		haystack += strlen(needle);
	}
	printf("found %d x %s\n", rv, needle);
	return rv;
}

char *swap(char const str[], char const dog[], char const cat[])
{
	size_t rvsize = strlen(str) + 1;
	rvsize += count(str, dog) * (strlen(cat) - strlen(dog));
	rvsize += count(str, cat) * (strlen(dog) - strlen(cat));
	printf("sizeof str: %d\n", strlen(str) + 1);
	printf("sizeof rvstr: %d\n", rvsize);
	char *rv = malloc0(rvsize);
	size_t src = 0, dst = 0;
	while (src < strlen(str) + 1) {
		if (!strncmp(&str[src], dog, strlen(dog))) {
			strcat(rv, cat);
			dst += strlen(cat);
			src += strlen(dog);
		} else if (!strncmp(&str[src], cat, strlen(cat))) {
			strcat(rv, dog);
			dst += strlen(dog);
			src += strlen(cat);
		} else {
			rv[dst++] = str[src++];
		}
	}
	return rv;
}

int main()
{
	char const dog[] = "bird", cat[] = "cat";
	char const s1[] = "That stupid bird had a shit on my catbirdcat bird";
	char const *s2 = swap(s1, dog, cat);
	puts(s2);
	free(s2);
	return 0;
}
