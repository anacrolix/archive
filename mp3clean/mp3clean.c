#define _FILE_OFFSET_BITS 64

#include <stdlib.h>
#include <openssl/sha.h>
#include <string.h>
#include <error.h>
#include <errno.h>
#include <assert.h>
#include <strings.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

typedef enum {no = 0, yes} has_t;

#define fatal(errval, fmt, ...) \
	(error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#define warn(errval, fmt, ...) \
	(error_at_line(0, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#ifdef NDEBUG
#define debug(errval, fmt, ...)
#else
#define debug(errval, fmt, ...) \
	(error_at_line(0, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))
#endif

#define MIN(a, b) ((a < b) ? a : b)
#define MAX(a, b) ((a > b) ? a : b)

int sha1_file_ex(
	FILE *fstream,
	unsigned char msgdgst[],
	off_t start,
	off_t end)
{
	assert(sizeof(size_t) >= sizeof(long));
	assert(end >= start && end >= 0 && start >= 0);
	int ret = 1;
	void *filedata = NULL;
	long bufsize = sysconf(_SC_PAGESIZE);

	do {
		if (fseek(fstream, start, SEEK_SET)) {
			warn(errno, "fseeko()");
			break;
		}

		filedata = malloc(bufsize);
		if (!filedata) {
			warn(errno, "malloc()");
			break;
		}

		SHA_CTX shactx;
		if (SHA1_Init(&shactx) != 1) break;

		size_t hashcnt = 0;
		do {
			size_t reqcnt = MIN(end - start - hashcnt, bufsize);
			size_t readcnt = fread(filedata, 1, reqcnt, fstream);
			if (readcnt < reqcnt && (feof(fstream) || ferror(fstream))) {
				warn(errno, "fread()");
				break;
			}
			assert(readcnt == reqcnt);
			if (SHA1_Update(&shactx, filedata, readcnt) != 1) break;
			hashcnt += readcnt;
		} while (hashcnt < end - start);
		if (hashcnt < end - start) break;
		assert(hashcnt == end - start);

		if (SHA1_Final(msgdgst, &shactx) != 1) break;

		ret = 0;
	} while (0);

	if (filedata) free(filedata);
	return ret;
}

has_t get_id3v2(FILE *fs, off_t *size)
{
	assert(fs != NULL);
	has_t ret = no;
	unsigned char v2hdr[10];

	do {
		if (fseek(fs, 0, SEEK_SET)) {
			warn(errno, "fseek()");
			break;
		}
		size_t read = fread(v2hdr, 1, sizeof(v2hdr), fs);
		if (read < sizeof(v2hdr)) {
			if (feof(fs) || ferror(fs)) warn(errno, "fread()");
			else assert(0);
			break;
		}
		// file ident
		if (strncmp((char *)&v2hdr[0], "ID3", 3))
			break;
		// version
		if (v2hdr[3] == 0xff || v2hdr[4] == 0xff)
			break;
		// flags
		assert(v2hdr[5] == 0);
		if (v2hdr[5] != 0) {
			warn(0, "ID3v2 flag processing is not implemented");
			break;
		}
		// 7 bit, bigendian size
		{
			int i;
			for (i = 6; i < 10; i++) {
				if (v2hdr[i] >> 7 || v2hdr[i] & 0x80) {
					assert(v2hdr[i] >> 7 && v2hdr[i] & 0x80);
					break;
				}
			}
			assert(i == 10);
			if (i != 10) break;
		}
		// get 28 bit size
		if (size != NULL) {
			*size = 0;
			assert(sizeof(off_t) >= sizeof(long));
			long flagval = 0;
			for (int i = 0; i < 4; i++) {
				long incval = v2hdr[9 - i];
				incval = incval << (i * 7);
				flagval |= incval;
			}
			*size = flagval;
		}
		ret = yes;
	} while (0);

	return ret;
}

has_t get_id3v1(FILE *fs)
{
	assert(fs != NULL);
	const static size_t TAG_SIZE = 128;
	has_t ret = no;
	char *v1tag = NULL;

	do {
		if (fseek(fs, -TAG_SIZE, SEEK_END)) {
			warn(errno, "fseek()");
			break;
		}
		v1tag = malloc(TAG_SIZE);
		if (v1tag == NULL) {
			warn(errno, "malloc()");
			break;
		}
		size_t read = fread(v1tag, 1, TAG_SIZE, fs);
		if (read < TAG_SIZE) {
			if (feof(fs) || ferror(fs))
				warn(errno, "fread()");
			else
				assert(0);
			break;
		}
		if (strncmp(&v1tag[0], "TAG", 3))
			break;
		ret = yes;
	} while (0);

	if (v1tag != NULL)
		free(v1tag);

	return ret;
}

int main(int argc, char *argv[])
{
	//debug(0, "system page size is %ld\n", sysconf(_SC_PAGESIZE));
	debug(0, argv[1]);
	int ret = EXIT_FAILURE;
	FILE *fs = NULL;

	do {
		fs = fopen(argv[1], "r");
		if (!fs) {
			warn(errno, "fopen()");
			break;
		}

		off_t start = 0;
		if (get_id3v2(fs, &start)) {
			start += 10;
			assert(sizeof(start) == sizeof(long long int));
			debug(0, "id3v2 header with length %lld", start);
		}

		if (fseek(fs, 0, SEEK_END)) {
			warn(errno, "fseeko()");
			break;
		}
		off_t end = ftell(fs);
		if (get_id3v1(fs)) {
			debug(0, "id3v1 header found");
			end -= 128;
		}

		unsigned char md[20];
		if (sha1_file_ex(fs, md, start, end)) {
			warn(0, "sha1_file_ex() failed");
			break;
		}

		for (int i = 0; i < 20; i++) printf("%02x", md[i]);
		putchar('\n');
		ret = EXIT_SUCCESS;
	} while (0);

	if (fs) {
		int n = fclose(fs);
		if (n) {
			assert(n == EOF);
			fatal(errno, "fclose()");
		}
	}

	return ret;
}
