#include <stdbool.h>
#include <stdio.h>

# define NR_RSA_COMPONENTS 8

typedef struct rsa_st RSA;

typedef union {
	struct { char *n, *e, *d, *p, *q, *dmp1, *dmq1, *iqmp; } value;
	char *array[NR_RSA_COMPONENTS];
} rsa_vals_sz;

struct rsa_value_desc_st {
	char const *n, *e, *d, *p, *q, *dmp1, *dmq1, *iqmp;
} extern const rsa_value_descs;

void init_rsa();
void fini_rsa();

RSA * rsa_new_keypair(int bits);
void rsa_free(RSA ** rsa);

int rsa_public_encrypt(RSA * rsa, int flen, void * from, void * to);
int rsa_private_decrypt(RSA * rsa, int flen, void * from, void * to);

rsa_vals_sz * rsa_values_dec(RSA * rsa);
rsa_vals_sz * rsa_values_hex(RSA * rsa);
void rsa_values_free(rsa_vals_sz * vals);

bool rsa_save_public(RSA * rsa, FILE * fp);
bool rsa_save_private(RSA * rsa, FILE * fp);
RSA * rsa_load_public(RSA ** rsa, FILE * fp);
RSA * rsa_load_private(RSA ** rsa, FILE * fp);
