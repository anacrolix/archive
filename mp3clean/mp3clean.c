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
#include <ftw.h>

typedef enum {no = 0, yes} has_t;

#define fatal(errval, fmt, ...) \
	(error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#ifdef NDEBUG
#define warn(errval, fmt, ...)
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

char *strrcasestr(const char *hay, const char *ndl)
{
	char *ret = NULL;
	size_t haylen = strlen(hay);
	size_t ndllen = strlen(ndl);
	if (ndllen > haylen) goto done;
	assert(haylen >= ndllen);
	ssize_t i;
	for (i = haylen - ndllen; i >= 0; i--) {
		if (!strncasecmp(&hay[i], ndl, ndllen)) {
			break;
		}
	}
	if (i == -1) goto done;
	ret = (char *)&hay[i];
done:
	return ret;
}

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

int mp3_data_bounds(FILE *fs, off_t *start, off_t *end)
{
	int ret = 1;
	// get start of mp3 data
	*start = 0;
	if (get_id3v2(fs, start)) {
		*start += 10;
		assert(sizeof(*start) == sizeof(long long int));
		debugln("id3v2 header found with length %lld", *start);
	}

	// get end of mp3 data
	if (fseek(fs, 0, SEEK_END)) {
		warn(errno, "fseek()");
		goto done;
	}
	*end = ftell(fs);
	if (get_id3v1(fs)) {
		debugln("id3v1 header found");
		*end -= 128;
	}

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

void add_datahash(
	FILE *fs,
	const char *name,
	const struct stat *stat)
{
	off_t start, end;
	if (mp3_data_bounds(fs, &start, &end)) goto done;
	assert(sizeof(off_t) == sizeof(long long));
	assert(sizeof(stat->st_size) == sizeof(long long));
	assert(end >= start);
	debugln("data len == %llu, file len == %llu", end - start, stat->st_size);
	datahash_t dh;
	dh.size = end - start;
	assert(strlen(name) < sizeof(dh.name));
	strncpy(dh.name, name, sizeof(dh.name));
	for (int i = 0; i < g_hashcnt; i++) {
		assert(strcmp(g_hashes[i].name, dh.name));
		if (dh.size == g_hashes[i].size) {
			printf("SIZE MATCH:\n\t%s\n\t%s\n",
				g_hashes[i].name, dh.name);
			FILE *fs2 = fopen(g_hashes[i].name, "r");
			if (!fs2) {
				warn(errno, "fopen()");
				continue;
			}
			sha1_mp3_data(fs2, g_hashes[i].md);
			sha1_mp3_data(fs, dh.md);
			if (!memcmp(g_hashes[i].md, dh.md, sizeof(dh.md))) {
				printf("HASH MATCH:\n\t%s\n\t%s\n", g_hashes[i].name, dh.name);
			}
		}
	}
	g_hashes[g_hashcnt++] = dh;
done:
	return;
}

int mp3_parse_callback(
	const char *name,
	const struct stat *stat,
	int info)
{
	debugln(name);
	FILE *fs = NULL;

	if (info != FTW_F) goto done;
	if (!has_mp3_ext(name)) goto done;

	fs = fopen(name, "r");
	if (!fs) goto done;

	add_datahash(fs, name, stat);

done:
	if (fs) fclose(fs);
	return 0;
}

int mp3_count_callback(
	const char *name,
	const struct stat *stat,
	int info)
{
	if (info != FTW_F || !has_mp3_ext(name)) goto done;
	g_hashmax++;
done:
	return 0;
}

int main(int argc, char *argv[])
{
	int ret = EXIT_FAILURE;
	debugln("system page size is %ld", sysconf(_SC_PAGESIZE));
	debugln("argv[1] == %s", argv[1]);

	if (ftw(argv[1], mp3_count_callback, 10)) {
		debugln("ftw() failed");
		goto done;
	}

	printf("mp3's found == %u\n", g_hashmax);
	g_hashes = calloc(g_hashmax, sizeof(*g_hashes));
	if (!g_hashes) {
		warn(errno, "calloc()");
		goto done;
	}

	if (ftw(argv[1], mp3_parse_callback, 10)) {
		debugln("ftw() failed");
		goto done;
	}

	ret = EXIT_SUCCESS;
done:
	if (g_hashes) free(g_hashes);
	return ret;
}
