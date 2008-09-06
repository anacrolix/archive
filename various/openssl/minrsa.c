#include "minrsa.h"

#include <assert.h>
#include <stddef.h>
#include <openssl/rsa.h>
#include <openssl/err.h>

#define RSA_FIELD(member, name) {offsetof(RSA, member), name}
struct {
	ptrdiff_t off;
	char const *name;
} const RSA_FIELD_NAMES[NR_RSA_COMPONENTS] = {
	RSA_FIELD(n, "public modulus"),
	RSA_FIELD(e, "public exponent"),
	RSA_FIELD(d, "private exponent"),
	RSA_FIELD(p, "secret prime factor \"p\""),
	RSA_FIELD(q, "secret prime factor \"q\""),
	RSA_FIELD(dmp1, "d mod (p-1)"),
	RSA_FIELD(dmq1, "d mod (q-1)"),
	RSA_FIELD(iqmp, "q^-1 mod p"),
};
#undef RSA_FIELD

struct rsa_value_desc_st const rsa_value_descs =
{
	"public modulus",
	"public exponent",
	"private exponent",
	"secret prime factor \"p\"",
	"secret prime factor \"q\"",
	"d mod (p-1)",
	"d mod (q-1)",
	"q^-1 mod p",
};

static long unsigned EXPONENT = 0x10001UL; // 65357 ?
static int PADDING = RSA_PKCS1_OAEP_PADDING;

void init_rsa()
{
	ERR_load_crypto_strings();
}

void fini_rsa()
{
	ERR_free_strings();
}

RSA * rsa_new_keypair(int bits)
{
	return RSA_generate_key(bits, EXPONENT, NULL, NULL);
}

int rsa_public_encrypt(RSA * rsa, int flen, void * from, void * to)
{
	int tlen = RSA_public_encrypt(flen, from, to, rsa, PADDING);
	assert(tlen != -1);
	return tlen;
}

int rsa_private_decrypt(RSA * rsa, int flen, void * from, void * to)
{
	int tlen = RSA_private_decrypt(
		flen, from, to, rsa, PADDING);
	assert(tlen != -1);
	return tlen;
}

static rsa_vals_sz * get_rsa_values(RSA * rsa, char *(func)(BIGNUM const *))
{
	char **vals = malloc(NR_RSA_COMPONENTS * sizeof(char *));
	for (int i = 0; i < NR_RSA_COMPONENTS; i++) {
		BIGNUM **bn = (void *)(rsa) + RSA_FIELD_NAMES[i].off;
		vals[i] = func(*bn);
	}

	assert(NR_RSA_COMPONENTS * sizeof(char *) == sizeof(rsa_vals_sz));
	return (rsa_vals_sz *)(vals);
}

rsa_vals_sz * rsa_values_dec(RSA * rsa)
{
	return get_rsa_values(rsa, BN_bn2dec);
}

rsa_vals_sz * rsa_values_hex(RSA * rsa)
{
	return get_rsa_values(rsa, BN_bn2hex);
}

void rsa_values_free(rsa_vals_sz * vals)
{
	for (int i = 0; i < NR_RSA_COMPONENTS; i++) {
		OPENSSL_free(vals->array[i]);
	}
	free(vals);
}

#if 0
	assert(1 == PEM_write_RSAPrivateKey(
		stdout,
		rsa,
		NULL, NULL, 0, NULL, NULL, NULL));

#endif
