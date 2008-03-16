#define _FILE_OFFSET_BITS 64

#include <stdlib.h>
#include <openssl/sha.h>
#include <string.h>
//#include <musicbrainz/mb_c.h>
#include <error.h>
#include <errno.h>
#include <assert.h>
//#include <id3tag.h>
#include <strings.h>
#include <stdio.h>
#include <unistd.h>

typedef enum {no = 0, yes} has_t;
//typedef __off64_t off_t;

#define fatal(errval, fmt, ...) (error_at_line(EXIT_FAILURE, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))

#ifdef NDEBUG
#define warn(errval, fmt, ...) (error_at_line(0, errval, __FILE__, __LINE__, fmt, ##__VA_ARGS__))
#else
#define warn(errval, fmt, ...) ({printf(fmt, ##__VA_ARGS__); puts(strerror(errval));})
#endif

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

has_t has_id3v2(FILE *fs, __off64_t *size)
{
	has_t ret = no;
	unsigned char v2hdr[10];
	
	do {
		if (fseek(fs, 0, SEEK_SET)) {
			warn(errno, "fseek()");
			break;
		}
		size_t read = fread(v2hdr, 1, 10, fs);
		if (read < 10) {
			if (ferror(fs))
				warn(errno, "fread()");
			else if (feof(fs))
				warn(0, "fread(), file too short?");
			else
				assert(0);
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
		if (v2hdr[5] != 0)
			break;
		// 7 bit, bigendian size
		for (int i = 6; i < 10; i++) {
			if (v2hdr[i] >> 7 || v2hdr[i] & 0x80) {
				assert(0);
				break;
			}
		}
		if (size != NULL) {
			*size = 0;
			assert(sizeof(__off_t) >= sizeof(long));
			long flagsize = 0;
			for (int i = 0; i < 4; i++) {
				long incsize = v2hdr[9 - i];
				incsize = incsize << (i * 7);
				flagsize |= incsize;
			}
			*size = flagsize;
		}
		ret = yes;
	} while (0);
	
	return ret;
}

has_t has_id3v1(FILE *fs)
{
	const static size_t TAG_SIZE = 128;
	has_t ret = no;
	char *v1tag = NULL;
	
	do {
		if (fseek(fs, -TAG_SIZE, SEEK_END)) {
			warn(errno, "fseek(), file too short?");
			break;
		}
		v1tag = malloc(TAG_SIZE);
		if (v1tag == NULL) break;
		size_t read = fread(v1tag, 1, TAG_SIZE, fs);
		if (read < TAG_SIZE) {
			if (ferror(fs))
				warn(errno, "fread()");
			else if (feof(fs))
				warn(0, "file too short?");
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
	debug("system page size is %ld\n", sysconf(_SC_PAGESIZE));
	
	int ret = EXIT_FAILURE;
	/*
	unsigned char md[20];
	
	if (!sha1_file(argv[1], md)) {
		for (int i = 0; i < 20; i++) printf("%02x", md[i]);	
		putchar('\n');
	}
	*/
	
	FILE *fs = NULL;
	
	do {
		fs = fopen(argv[1], "r");
		if (fs == NULL) {
			warn(errno, "fopen()");
			break;
		}
		__off64_t blah;
		if (has_id3v2(fs, &blah)) {
			assert(sizeof(blah) == sizeof(long long int));
			debug("id3v2 flag with length %lld\n", blah);
		}
		ret = EXIT_SUCCESS;
	} while (0);

	if (fs != NULL) {
		int n = fclose(fs);
		if (n != 0) {
			assert(n == EOF);
			fatal(errno, "fclose()");
		}
	}
	
	return ret;
}

/*
void mp3_sig(const char *filename, char sig[])
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
			trm_t o = trm_New();
			for (;;) {
				size_t bytesread = fread(filedata, 1, bufsize, fstream);
				if (bytesread < bufsize && ferror(fstream)) {
					warn(errno, "fread()");
					break;
				}		
				if (trm_GenerateSignature(o, filedata, bytesread) == 1) {
					trm_FinalizeSignature(o, sig, NULL);
					break;
				}
				if (bytesread < bufsize && feof(fstream)) {
					if (trm_)
						ret = 1;
					break;
				}
			}
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
*/

/*
void mp3_data_hash(const char *filename)
{
	struct id3_file *id3file = id3_file_open(filename, ID3_FILE_MODE_READONLY);
	union id3_field field;
	id3_length_t *len;
	id3_byte_t *bindata = id3_field_getbinarydata(&field, len);
	assert(sizeof(id3_byte_t) == sizeof(unsigned char));
	debug("bindata == %hhd\n", bindata);
	debug("field == %x\n", field);
	debug("len == %u\n", len);
	id3_file_close(id3file);
}
*/
