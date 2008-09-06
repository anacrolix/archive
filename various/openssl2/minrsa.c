#include "minrsa.h"

#include <assert.h>
#include <stddef.h>
#include <stdbool.h>
#include <openssl/rsa.h>
#include <openssl/err.h>
#include <openssl/pem.h>

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
static int PADDING_TYPE = RSA_PKCS1_OAEP_PADDING;
static int PADDING_SIZE = 41;

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

void rsa_free(RSA ** rsa)
{
	RSA_free(*rsa);
	*rsa = NULL;
}

/**
@param flen: Number of bytes at from
@param to: Must point to RSA_size(rsa) bytes
*/
int rsa_public_encrypt(RSA * rsa, int flen, void * from, void * to)
{
	assert(flen < RSA_size(rsa) - PADDING_SIZE);
	int tlen = RSA_public_encrypt(flen, from, to, rsa, PADDING_TYPE);
	assert(tlen != -1);
	assert(tlen == RSA_size(rsa));
	return tlen;
}

int rsa_private_decrypt(RSA * rsa, int flen, void * from, void * to)
{
	int tlen = RSA_private_decrypt(
		flen, from, to, rsa, PADDING_TYPE);
	assert(tlen != -1);
	assert(tlen < RSA_size(rsa) - PADDING_SIZE); // curious
	return tlen;
}

static rsa_vals_sz * get_rsa_values(RSA * rsa, char *(func)(BIGNUM const *))
{
	char **vals = malloc(NR_RSA_COMPONENTS * sizeof(char *));
	for (int i = 0; i < NR_RSA_COMPONENTS; i++) {
		BIGNUM **bn = (void *)(rsa) + RSA_FIELD_NAMES[i].off;
		if (*bn)
			vals[i] = func(*bn);
		else
			vals[i] = NULL;
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

bool rsa_save_private(RSA * rsa, FILE * fp)
{
	int pem_rv = PEM_write_RSAPrivateKey(
		fp, rsa, NULL, NULL, 0, NULL, NULL);
	assert(pem_rv == 0 || pem_rv == 1);
	return pem_rv;
}

bool rsa_save_public(RSA * rsa, FILE * fp)
{
	int pem_rv = PEM_write_RSAPublicKey(fp, rsa);
	assert(pem_rv == 0 || pem_rv == 1);
	return pem_rv;
}

RSA * rsa_load_public(RSA ** rsa, FILE * fp)
{
	RSA *pem_rv = PEM_read_RSAPublicKey(fp, rsa, NULL, NULL);
	assert(pem_rv);
	return pem_rv;
}

RSA * rsa_load_private(RSA ** rsa, FILE * fp)
{
	RSA *pem_rv = PEM_read_RSAPrivateKey(fp, rsa, NULL, NULL);
	assert(pem_rv);
	return pem_rv;
}
