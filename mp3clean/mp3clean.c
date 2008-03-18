#define _FILE_OFFSET_BITS 64

#include <stdlib.h>
#include <openssl/sha.h>
#include <string.h>
#include <error.h>
#include <errno.h>
#include <assert.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <ftw.h>
#include "../eruutil/strrchr.h"

typedef enum {no = 0, yes} has_t;

#define fatal(errval, fmt, ...) \
	(error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#ifdef NDEBUG
#define warn(errval, fmt, ...) \
	(fprintf(stderr, fmt, ##__VA_ARGS__))
#else
#define warn(errval, fmt, ...) \
	(error_at_line(0, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))
#endif

#ifdef NDEBUG
#define debug(fmt, ...)
#define debugln(fmt, ...)
#else
#define debug(fmt, ...) \
	(fprintf(stderr, fmt, ##__VA_ARGS__))
#define debugln(fmt, ...) \
	({fprintf(stderr, fmt, ##__VA_ARGS__); fputc('\n', stderr);})
#endif

#define MIN(a, b) ((a < b) ? a : b)
#define MAX(a, b) ((a > b) ? a : b)

typedef struct {
	unsigned char md[20];
	off_t size;
	char name[0x100];
} datahash_t;

size_t g_hashcnt = 0;
size_t g_hashmax = 0;
datahash_t *g_hashes = NULL;

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
	assert(fs);
	has_t ret = no;
	*size = 0;
	unsigned char v2hdr[10];
	if (fseek(fs, 0, SEEK_SET)) {
		warn(errno, "fseek()");
		goto done;
	}
	size_t read = fread(v2hdr, 1, sizeof(v2hdr), fs);
	if (read < sizeof(v2hdr)) {
		if (feof(fs) || ferror(fs)) warn(errno, "fread()");
		else assert(0);
		goto done;
	}
	// file ident
	if (strncmp((char *)&v2hdr[0], "ID3", 3)) goto done;
	// version
	if (v2hdr[3] == 0xff || v2hdr[4] == 0xff) goto done;
	// flags
	if (v2hdr[5] != 0) {
		warn(0, "%s contains unimplemented ID3v2 flags");
		assert(0);
		goto done;
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
		if (i != 10) goto done;
	}
	// get 28 bit size
	if (size != NULL) {
		*size = 10;
		assert(sizeof(off_t) >= sizeof(long));
		long flagval = 0;
		for (int i = 0; i < 4; i++) {
			long incval = v2hdr[9 - i];
			incval = incval << (i * 7);
			flagval |= incval;
		}
		*size += flagval;
	}
	ret = yes;
done:
	return ret;
}

has_t get_id3v1(FILE *fs)
{
	assert(fs);
	const static size_t TAG_SIZE = 128;
	has_t ret = no;
	char *v1tag = NULL;
	if (fseek(fs, -TAG_SIZE, SEEK_END)) {
		warn(errno, "fseek()");
		goto done;
	}
	v1tag = malloc(TAG_SIZE);
	if (v1tag == NULL) {
		warn(errno, "malloc()");
		goto done;
	}
	size_t read = fread(v1tag, 1, TAG_SIZE, fs);
	if (read < TAG_SIZE) {
		if (feof(fs) || ferror(fs)) warn(errno, "fread()");
		else assert(0);
		goto done;
	}
	if (strncmp(&v1tag[0], "TAG", 3)) goto done;
	ret = yes;
done:
	if (v1tag != NULL) free(v1tag);
	return ret;
}

int mp3_data_bounds(FILE *fs, off_t *start, off_t *end)
{
	int ret = 1;
	
	// get start of mp3 data
	get_id3v2(fs, start);

	// get end of mp3 data
	if (fseek(fs, 0, SEEK_END)) {
		warn(errno, "fseek()");
		goto done;
	}
	*end = ftell(fs);
	if (get_id3v1(fs)) *end -= 128;
	
	assert(sizeof(off_t) == sizeof(long long));
	debugln("mp3 data has bounds [%llu, %llu]", *start, *end);

	ret = 0;
done:
	return ret;
}

int sha1_mp3_data(FILE *fs, unsigned char md[])
{
	int ret = 1;

	off_t start, end;
	if (mp3_data_bounds(fs, &start, &end)) {
		debugln("mp3_data_bounds() failed");
		goto done;
	}

	// hash mp3 data
	if (sha1_file_ex(fs, md, start, end)) {
		warn(0, "sha1_file_ex() failed");
		goto done;
	}

	for (int i = 0; i < 20; i++) debug("%02x", md[i]);
	fputc('\n', stderr);

	ret = 0;

done:
	return ret;
}

int has_mp3_ext(const char *name)
{
	static const char MP3_EXT[] = ".mp3";
	return (strrcasestr(name, ".mp3") == name + strlen(name) - strlen(MP3_EXT));
}

int parse_mp3_size_callback(
	const char *name,
	const struct stat *stat,
	int info)
{
	debugln(name);
	FILE *fs = NULL;
	
	// check there is room
	if (g_hashcnt >= g_hashmax) goto done;

	// check mp3 file
	if (info != FTW_F) goto done;
	if (!has_mp3_ext(name)) goto done;

	// get file handle
	fs = fopen(name, "r");
	if (!fs) {
		warn(errno, "fopen()");
		goto done;
	}
	
	// get data bounds
	off_t start, end;
	if (mp3_data_bounds(fs, &start, &end)) {
		warn(0, "mp3_data_bounds() failed");
		goto done;
	}
	
	// create datahash object
	datahash_t dh;
	assert(sizeof(dh.name) == 0x100);
	assert(strlen(name) < sizeof(dh.name));
	strncpy(dh.name, name, sizeof(dh.name));
	assert(end >= start);
	dh.size = end - start;
	
	// add datahash object
	g_hashes[g_hashcnt++] = dh;
	assert(g_hashcnt <= g_hashmax);

done:
	if (fs) fclose(fs);
	return 0;
}

int mp3_count_callback(
	const char *name,
	const struct stat *stat,
	int info)
{
	if (info == FTW_F && has_mp3_ext(name)) {
		g_hashmax++;
	}
	return 0;
}

void usage()
{
	puts("Invalid parameters specified.");
	puts("Correct usage: <program> <path>");
}

void find_mp3_dupes(const char *dirname)
{
	// count mp3 files
	if (ftw(dirname, mp3_count_callback, 10)) {
		warn(0, "ftw() failed");
		goto done;
	}
	printf("Found %u MP3 files\n", g_hashmax);
	
	// allocate room for mp3 info
	g_hashes = calloc(g_hashmax, sizeof(*g_hashes));
	if (!g_hashes) {
		warn(errno, "calloc()");
		goto done;
	}

	// parse mp3 files
	if (ftw(dirname, parse_mp3_size_callback, 10)) {
		warn(0, "ftw() failed");
		goto done;
	}
	
	assert(g_hashcnt == g_hashmax);

	if (g_hashes) free(g_hashes);
	return;
done:
	exit(EXIT_FAILURE);
}

int main(int argc, char *argv[])
{
	int ret = EXIT_FAILURE;
	
	// do some checks
	debugln("system page size = %ld", sysconf(_SC_PAGESIZE));
	if (argc != 2) {
		usage();
		goto done;
	}
	debugln("argv[1] = %s", argv[1]);
	
	// parse mp3 files
	find_mp3_dupes(argv[1]);

	ret = EXIT_SUCCESS;
done:
	return ret;
}
