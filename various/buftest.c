#include <sys/stat.h>
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void revbuf(char *dst, char const *src, size_t len)
{
	for (dst += len - 1; len-- > 0; *dst-- = *src++);
}

int main(int argc, char *argv[])
{
	printf("BUFSIZE: %d\n", BUFSIZ);

	// check params
	assert(argc == 2);
	char const *outname = argv[1];
	FILE *outstream = fopen(outname, "w");
	assert(outstream);

	// create working buffer
	size_t const bufsize = 0x200;
	void *buf = malloc(bufsize); // guess why i picked this
	assert(buf);

	// try something retarded
	struct stat stdin_stat;
	assert(!fstat(0, &stdin_stat));
	printf("stdin has size: %ld\n", stdin_stat.st_size);
	printf("stdin isatty: %d\n", isatty(0));

	// store stdin
	FILE *tmpf = tmpfile();
	assert(tmpf);
	do {
		size_t b_in = fread(buf, 1, bufsize, stdin);
		if (b_in != bufsize) assert(!ferror(stdin));
		size_t b_out = fwrite(buf, 1, b_in, tmpf);
		assert(b_out == b_in);
		if (b_in == bufsize || !feof(stdin))
			continue;
		else
			break;
	} while (true);

	// look at tmpfile size
	assert(!fseek(tmpf, 0, SEEK_END));
	long tmpf_size = ftell(tmpf);
	assert(tmpf_size != -1 && tmpf_size >= 0);
	printf("tmpfile has end at: %ld\n", tmpf_size);

	void *inbuf, *outbuf;
	assert(inbuf = malloc(bufsize));
	assert(outbuf = malloc(bufsize));
	for (long inoff = tmpf_size - bufsize; inoff >= 0; inoff -= bufsize) {
		assert(!fseek(tmpf, inoff, SEEK_SET));
		assert(fread(inbuf, 1, bufsize, tmpf) == bufsize);
		revbuf(outbuf, inbuf, bufsize);
		assert(fwrite(outbuf, 1, bufsize, outstream) == bufsize);
	}

	return EXIT_SUCCESS;
}
