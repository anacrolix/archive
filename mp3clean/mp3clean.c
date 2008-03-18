#define _FILE_OFFSET_BITS 64

#include <stdlib.h>
#include <openssl/sha.h>
#include <string.h>
#include <errno.h>
#include <assert.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <ftw.h>
#include "../eruutil/strrchr.h"
#include "../eruutil/memnotchr.h"
#include "../eruutil/erudebug.h"

typedef enum {no = 0, yes} has_t;

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

//static_assert(sizeof(char) > sizeof(long));
static_assert(sizeof(size_t) >= sizeof(long));
static_assert(sizeof(off_t) >= sizeof(long));
static_assert(sizeof(off_t) == sizeof(long long));
static_assert(sizeof(g_hashes->md) == SHA_DIGEST_LENGTH);

int sha1_file_ex(
	FILE *fstream,
	unsigned char msgdgst[],
	off_t start,
	off_t end)
{
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
		warn(0, "TODO: contains unimplemented ID3v2 flags");
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
	debug("\n");

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
	memset(dh.md, '\0', sizeof(dh.md));
	
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
		debugln(name);
		g_hashmax++;
	}
	return 0;
}

void usage()
{
	puts("Invalid parameters specified.");
	puts("Correct usage: <program> <path>");
}

void get_size_matches(off_t *matches[], int *matchcnt)
{
	size_t matchmax = 100;
	*matchcnt = 0;
	*matches = malloc(matchmax * sizeof(**matches));
	if (*matches == NULL) goto done;
	for (int i = 0; i < g_hashcnt; i++) {
		off_t size = g_hashes[i].size;
		// skip this size if it's already recorded
		int match;
		for (match = 0; match < *matchcnt; match++) {
			if (size == (*matches)[match]) {
				break;
			}
		}
		assert(match >= 0 && match <= *matchcnt);
		if (match < *matchcnt) continue;
		// skip if no duplicates of this size found
		for (match = i + 1; match < g_hashcnt; match++) {
			if (size == g_hashes[match].size) {
				break;
			}
		}
		assert(match >= i + 1 && match <= g_hashcnt);
		if (match == g_hashcnt) continue;
		// add match
		assert(*matchcnt <= matchmax);
		if (*matchcnt == matchmax) {
			matchmax *= 2;
			assert(matchmax > *matchcnt);
			*matches = realloc(*matches, matchmax * sizeof(**matches));
			if (matches == NULL) fatal(errno, "realloc()");
		}
		(*matches)[(*matchcnt)++] = size;
	}
done:
	debugln("setting buffer size to %d bytes (%d items)", *matchcnt * sizeof(**matches), *matchcnt);
	off_t *resized = realloc(*matches, *matchcnt * sizeof(**matches));
	if (resized != NULL) *matches = resized;
}

void report_size_matches()
{
	off_t *matches;
	int matchcnt;
	get_size_matches(&matches, &matchcnt);
	assert(matches != NULL && matchcnt >= 0);
	for (int match = 0; match < matchcnt; match++) {
		off_t size = matches[match];
		printf("Matches for data size = %llu:\n", size);
		for (int i = 0; i < g_hashcnt; i++) {
			if (size == g_hashes[i].size) {
				printf("\t%s\n", g_hashes[i].name);
			}
		}
	}
//done:
	if (matches != NULL) free(matches);
}

void add_size_match_hashes()
{
	off_t *matches;
	int matchcnt;
	get_size_matches(&matches, &matchcnt);
	assert(matches != NULL && matchcnt >= 0);
	// hash all size matches
	for (int match = 0; match < matchcnt; match++) {
		// find objects that match size
		for (int i = 0; i < g_hashcnt; i++) {
			if (g_hashes[i].size != matches[match]) continue;
			// check a hash isn't already created
			int j;
			for (j = 0; j < SHA_DIGEST_LENGTH; j++) {
				if (g_hashes[i].md[j] != '\0') {
					debugln("already hashed: %s", g_hashes[i].name);
					break;
				}
			}
			if (j != SHA_DIGEST_LENGTH) continue;
			// open file and add hash
			FILE *fsp = fopen(g_hashes[i].name, "r");
			if (fsp == NULL) {
				warn(errno, "fopen()");
				continue;
			}
			if (sha1_mp3_data(fsp, g_hashes[i].md)) {
				warn(0, "sha1_mp3_data() failed");
			}
			fclose(fsp);
		}
	}
}

#ifndef NDEBUG
int hashmds_zeroed()
{
	for (int i = 0; i < g_hashmax; i++) {
		for (int j = 0; j < sizeof(g_hashes[i].md); j++) {
			if (g_hashes[i].md[j] != '\0') return 0;
		}
	}
	return 1;
}
#endif

void report_hash_matches()
{	
	for (int i = 0; i < g_hashmax; i++) {
		// check file has a hash
		if (memnotchr(g_hashes[i].md, '\0', sizeof(g_hashes[i].md)) == NULL) {
			continue;
		}
#ifndef NDEBUG
		{
			int j;
			for (j = 0; j < sizeof(g_hashes[i].md); j++) {
				if (g_hashes[i].md[j] != '\0') break;
			}
			assert(j != sizeof(g_hashes[i].md));
		}
#endif
		for (int j = 0; j < g_hashmax; j++) {
			if (i == j) continue;
			if (memcmp(g_hashes[i].md, g_hashes[j].md, sizeof(g_hashes[i].md)) != 0) {
				continue;
			}
			if (j < i) break;
			assert(j != i);
			printf("Matches for hash = ");
			for (int b = 0; b < sizeof(g_hashes[i].md); b++) {
				printf("%02x", g_hashes[i].md[b]);
			}
			puts(":");
			for (j = i; j < g_hashmax; j++) {
				if (!memcmp(g_hashes[i].md, g_hashes[j].md, sizeof(g_hashes[i].md))) {
					printf("\t%s\n", g_hashes[j].name);
				}
			}
			break;
		}
	}
}

void find_mp3_dupes(const char *dirname)
{
	// count mp3 files
	if (ftw(dirname, mp3_count_callback, 20)) {
		warn(0, "ftw() failed");
		goto done;
	}
	printf("Found %u MP3 files\n\n", g_hashmax);
	
	// allocate room for mp3 info
	g_hashes = malloc(g_hashmax * sizeof(*g_hashes));
	/*
	for (int i = 0; i < g_hashmax * sizeof(*g_hashes); i++) {
		assert(((char *)g_hashes)[i] == '\0');
	}
	*/
	if (!g_hashes) {
		warn(errno, "calloc()");
		goto done;
	}

	// parse mp3 files
	if (ftw(dirname, parse_mp3_size_callback, 20)) {
		warn(0, "ftw() failed");
		goto done;
	}
	assert(hashmds_zeroed());
	
	assert(g_hashcnt == g_hashmax);
	
	report_size_matches();
	assert(hashmds_zeroed());
	add_size_match_hashes();
	putchar('\n');
	report_hash_matches();	

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
