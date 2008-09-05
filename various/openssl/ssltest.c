#include <stdio.h>
#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <openssl/rsa.h>
#include <openssl/err.h>

#define dimof(array) (sizeof(array) / sizeof(*array))

typedef struct {
	int stage;
	FILE *fout;
} openssl_cb_arg;

#define INIT_OPENSSL_CB_ARG(a) \
	{.stage = -1, .fout = a}

void generate_rsa_key_callback(int stage, int try, void * _cb_arg)
{
	openssl_cb_arg *cb_arg = _cb_arg;
	switch (stage) {
	case 0:
		if (stage != cb_arg->stage)
			fprintf(cb_arg->fout, "generating potential primes ");
		fputc('.', cb_arg->fout);
		break;
	case 1:
		if (stage != cb_arg->stage)
			fprintf(cb_arg->fout, "\ntesting primality ");
		fputc('.', cb_arg->fout);
		break;
	case 2:
		assert(stage != cb_arg->stage);
		fprintf(cb_arg->fout, "rejected prime #%d\n", try);
		break;
	case 3:
		assert(stage != cb_arg->stage);
		assert(!(try & ~1)); // try should be 0 or 1
		fprintf(cb_arg->fout, "\nfound %s prime!\n",
			try ? "second" : "first");
		break;
	default:
		assert(false);
	}
	cb_arg->stage = stage;
}

#define __RSA_FIELD_(member, name) {offsetof(RSA, member), name}

struct {
	ptrdiff_t off;
	char const *name;
} RSA_FIELD_NAMES[] = {
	{offsetof(RSA, n), "public modulus"},
	{offsetof(RSA, e), "public exponent"},
	{offsetof(RSA, d), "private exponent"},
	__RSA_FIELD_(p, "first secret prime factor"),
	__RSA_FIELD_(q, "second secret prime factor"),
	__RSA_FIELD_(dmp1, "d mod (p-1)"),
	__RSA_FIELD_(dmq1, "d mod (q-1)"),
	__RSA_FIELD_(iqmp, "q^-1 mod p"),
};

#define NR_RSA_FIELDS dimof(RSA_FIELD_NAMES)

void print_rsa_values(RSA * rsa)
{
	for (int i = 0; i < NR_RSA_FIELDS; i++) {
		char *bn_as_dec = BN_bn2dec(*(BIGNUM **)(
			(void *)(rsa) + RSA_FIELD_NAMES[i].off));
		printf("%s\n%s\n", RSA_FIELD_NAMES[i].name, bn_as_dec);
		OPENSSL_free(bn_as_dec);
	}
}

int main (int argc, char * argv[])
{
	ERR_load_crypto_strings();

	int const nr_rsa_bits = 1024;
	openssl_cb_arg cb_arg = INIT_OPENSSL_CB_ARG(stderr);
	RSA *rsa = RSA_generate_key(
		nr_rsa_bits, 0x10001, generate_rsa_key_callback, &cb_arg);
	assert(rsa);
	print_rsa_values(rsa);

	assert(RSA_size(rsa) * 8 == nr_rsa_bits);
	char from[50] = {'\0'};
	strcpy(from, "hello there :)\n");
	unsigned char to[nr_rsa_bits / 8];
	int size = RSA_public_encrypt(50, (void*)from, to, rsa, RSA_PKCS1_OAEP_PADDING);
	if (size < 0)
		ERR_print_errors_fp(stderr);
	printf("%d\n", size);
	FILE *od = popen("od -t x1", "w");
	assert(od);
	assert(fwrite(to, 1, size, od) == size);
	pclose(od);
	assert(size != -1);

	assert(size == nr_rsa_bits / 8);
	char plaintext[size];
	size = RSA_private_decrypt(size, to, plaintext, rsa, RSA_PKCS1_OAEP_PADDING);
	assert(size != -1);

	printf("%s", plaintext);
	od = popen("od -A d -t x1", "w");
	assert(od);
	assert(fwrite(plaintext, 1, 128, od) == 128);
	pclose(od);

#if 0
	for (int i = 3; i < 8; i++) {
		BIGNUM **bn = (void *)(rsa) + RSA_FIELD_NAMES[i].off;
		BN_free(*bn);
		*bn = NULL;
	}
#endif
	RSA_print_fp(stdout, rsa, 0);

	assert(1 == PEM_write_RSAPrivateKey(
		stdout,
		rsa,
		NULL, NULL, 0, NULL, NULL, NULL));
#if 0
	FILE *fp, RSA *x, const EVP_CIPHER *enc,
                                        unsigned char *kstr, int klen,
                                        pem_password_cb *cb, void *u);
#endif

	ERR_free_strings();
	return 0;
}
