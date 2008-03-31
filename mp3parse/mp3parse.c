#define _FILE_OFFSET_BITS 64
#define _XOPEN_SOURCE

#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <string.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <assert.h>
#include <stdbool.h>
#include "../eruutil/erudebug.h"

#define ID3V2_SIZE_LEN 4

/*
typedef struct {
	unsigned int sync : 11;
	unsigned int version : 2;
	unsigned int layer : 2;
	unsigned int protection : 1;
	unsigned int bitrate : 4;
	unsigned int sampling : 2;
	unsigned int padding : 1;
	unsigned int private : 1;
	unsigned int channel : 2;
	unsigned int mode : 2;
	unsigned int copyright : 1;
	unsigned int original : 1;
	unsigned int emphasis : 2;
	off_t offset;
} mfh_t;
*/
typedef struct {
	unsigned int emphasis : 2;
	unsigned int original : 1;
	unsigned int copyright : 1;
	unsigned int mode : 2;
	unsigned int channel : 2;
	unsigned int private : 1;
	unsigned int padding : 1;
	unsigned int sampling : 2;
	unsigned int bitrate : 4;
	unsigned int protection : 1;
	unsigned int layer : 2;
	unsigned int version : 2;
	unsigned int sync : 11;
	//off_t offset;
} mfh_t;
//*/

typedef struct {
	char ident[3];
	unsigned char major;
	unsigned char revision;
	struct {
		unsigned char unsync : 1;
		unsigned char extended : 1;
		unsigned char experimental : 1;
	} flags;
	unsigned char size[ID3V2_SIZE_LEN];
} id3v2hdr_t;

typedef struct {
	char ident[3];
	char title[30];
	char artist[30];
	char album[30];
	unsigned char year[4];
	char comment[30];
	unsigned char genre;
} id3v1hdr_t;

//typedef unsigned long framehdr_t;

static_assert(sizeof(mfh_t) == 4);
static_assert(sizeof(id3v1hdr_t) == 128);
//static_assert(sizeof(mfh_t) == 12);
static_assert(sizeof(off_t) == sizeof(long long));
static_assert(sizeof(long) == 4);
static_assert(sizeof(id3v2hdr_t) == 10);
static_assert(sizeof(int) >= ID3V2_SIZE_LEN);
//static_assert(sizeof(framehdr_t) == 4);

bool validId3v1(id3v1hdr_t h)
{
	if (strncmp(h.ident, "TAG", 3)) return false;
	return true;
}

int lengthId3v1(id3v1hdr_t h)
{
	if (validId3v1(h)) return sizeof(id3v1hdr_t);
	return -1;
}

bool getId3v1(id3v1hdr_t *h, FILE *fs)
{
	bool ret = false;
	if (fseek(fs, -sizeof(id3v1hdr_t), SEEK_END)) goto done;
	if (fread(h, sizeof(id3v1hdr_t), 1, fs) != 1) goto done;
	if (!validId3v1(*h)) goto done;
	ret = true;
done:
	return ret;
}

bool validId3v2(id3v2hdr_t h)
{
	if (strncmp(h.ident, "ID3", 3)) return false;
	if (h.major >= 0x80 || h.revision >= 0x80) return false;
	for (int i = 0; i < ID3V2_SIZE_LEN; i++) {
		if (h.size[i] >= 0x80) return false;
	}
	return true;
}

int lengthId3v2(id3v2hdr_t h)
{
	if (!validId3v2(h)) return -1;
	int len = 0;
	for (int i = 0; i < ID3V2_SIZE_LEN; i++) {
		len += h.size[i] << ((ID3V2_SIZE_LEN - i - 1) * 7);
	}
	return len + 10;
}

bool getId3v2(id3v2hdr_t *h, FILE *fs)
{
	bool ret = false;
	if (fseek(fs, 0, SEEK_SET)) goto done;
	if (fread(h, sizeof(id3v2hdr_t), 1, fs) != 1) goto done;
	if (!validId3v2(*h)) goto done;
	ret = true;
done:
	return ret;
}

void printBits(char *c, int len)
{
	for (int b = 0; b < len; b++) {
		for (int i = 7; i >= 0; i--) {
			if ((c[b] >> i) & 1) {
				putchar('1');
			} else {
				putchar('0');
			}
		}
		putchar(' ');
	}
}

char flipBits(char c)
{
	char r = 0;
	for (int i = 0; i < 8; i++) {
		if ((c >> i) & 1) {
			r |= 1 << (7 - i);
		} else {
			r &= ~(1 << (7 - i));
		}
	}
	return r;
}

int validFrameHdr(mfh_t *mfh)
{
	int ret = 0;
	if (mfh->sync != 0x7ff) goto done;
	ret = 1;
done:
	return ret;
}

int lengthFrameHdr(mfh_t *mfh)
{

	int ret = -1;
	if (!validFrameHdr(mfh)) goto done;
	if (mfh->layer != 1) goto done;
	if (mfh->version != 3) goto done;
	static int MPEG_V1L3_BITRATE[16] = {
		-1, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, -1};
	int bitrate = MPEG_V1L3_BITRATE[mfh->bitrate];
	if (bitrate <= 0) {
		debugln("bad bitrate!");
		goto done;
	}
	bitrate *= 1000;
	static int MPEG_V1_SAMPLING[4] = {
		44100, 48000, 32000, -1};
	int sampling = MPEG_V1_SAMPLING[mfh->sampling];
	if (sampling <= 0) {
		debugln("bad sample rate!");
		goto done;
	}
	ret = 144 * bitrate / sampling;
	if (mfh->padding) ret += 1;
	if (mfh->protection == 0) ret += 16;
done:
	return ret;
}

int getFrameHdr(mfh_t *mfh, FILE *fs, off_t off)
{
	int ret = 0;
	if (fseek(fs, off, SEEK_SET)) goto done;
	if (fread(mfh, sizeof(*mfh), 1, fs) != 1) goto done;
	//printBits(fh, 4); putchar('\n');
	*(uint32_t *)mfh = ntohl(*(uint32_t *)mfh);
	if (!validFrameHdr(mfh)) goto done;
	ret = 1;
done:
	return ret;
}

int getDataBounds(off_t *start, off_t *end, FILE *fs)
{
	int ret = 0;
	id3v1hdr_t h1;
	id3v2hdr_t h2;
	off_t dataStart, dataEnd;
	if (fseek(fs, 0, SEEK_END)) goto done;
	dataEnd = ftell(fs);
	if (getId3v1(&h1, fs)) {
		dataEnd -= lengthId3v1(h1);
	}
	if (getId3v2(&h2, fs)) {
		dataStart = lengthId3v2(h2);
	} else {
		dataStart = 0;
	}
	debugln("tag headers indicate data [%llu, %llu]", dataStart, dataEnd);
	for (*start = 0; ; (*start)++) {
		mfh_t mfh;
		*end = *start;
		while (getFrameHdr(&mfh, fs, *end)) {
			debugln("trying offset %llu", *end);
			int len = lengthFrameHdr(&mfh);
			if (len <= sizeof(mfh)) {
				debugln("rejected frame based on length");
				break;
			}
			*end += len;
		}
		if (*end >= dataEnd) break;
	}
	debugln("frame headers indicate data [%llu, %llu]", *start, *end);
	if (*end != dataEnd) {
		debugln("frame extends beyond end of file!");
	}
	ret = 1;
done:
	return ret;
}

int main(int argc, char *argv[])
{
	debugln(argv[1]);
	FILE *fs = fopen(argv[1], "rb");
	if (!fs) goto done;
	off_t start, end;
	getDataBounds(&start, &end, fs);
done:
	fclose(fs);
	return 0;
}
