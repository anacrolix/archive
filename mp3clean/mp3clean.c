#include <stdlib.h>
#include <openssl/sha.h>
#include <string.h>
#include <stdio.h>
#include <musicbrainz/mb_c.h>
#include <error.h>
#include <errno.h>
#include <unistd.h>
#include <assert.h>

#define fatal(errval, fmt, ...) (error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#define warn(errval, fmt, ...) (error_at_line(0, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#ifndef NDEBUG
#define debug(fmt, ...) (fprintf(stderr, fmt, ##__VA_ARGS__))
#else
#define debug(fmt, ...)
#endif

int sha1_file(const char *filename, unsigned char msgdgst[])
{
	int ret = 0;
	
	FILE *fstream = fopen(filename, "r");
	if (fstream == NULL) {
		warn(errno, "fopen(\"%s\", \"r\")", filename);
		ret = 1;
	} else {
		long bufsize = sysconf(_SC_PAGESIZE);
		assert(sizeof(size_t) >= sizeof(long));
		void *filedata = malloc(bufsize);
		if (filedata == NULL) {
			warn(errno, "malloc()");
			ret = 1;
		} else {
			SHA_CTX shactx;
			do {
				if (SHA1_Init(&shactx) != 1) {
					ret = 1;
					break;
				}
				for (;;) {
					size_t bytesread = fread(filedata, 1, bufsize, fstream);
					if (bytesread < bufsize && ferror(fstream)) {
						warn(errno, "fread()");
						break;
					}		
					if (SHA1_Update(&shactx, filedata, bytesread) != 1) {
						ret = 1;
						break;
					}
					if (bytesread < bufsize && feof(fstream)) {
						if (SHA1_Final(msgdgst, &shactx) != 1)
							ret = 1;
						break;
					}
				}
			} while (0);
			free(filedata);
		}
		int n = fclose(fstream);
		if (n != 0) {
			assert(n == EOF);
			fatal(errno, "fclose()");
		}
	}
	return ret;
}

int main(int argc, char *argv[])
{
	debug("system page size is %ld\n", sysconf(_SC_PAGESIZE));
	unsigned char md[20];
	if (!sha1_file(argv[1], md)) {
		for (int i = 0; i < 20; i++) printf("%02x", md[i]);	
		putchar('\n');
	}
	return EXIT_SUCCESS;
}
