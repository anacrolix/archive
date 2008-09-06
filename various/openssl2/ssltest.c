#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

#include "minrsa.h"

void print_rsa(RSA * rsa)
{
	rsa_vals_sz *dec = rsa_values_dec(rsa);
	for (int i = 0; i < 8; i++) {
		if (!dec->array[i]) continue;
		printf("%s = %s\n", ((char **)&rsa_value_descs)[i], dec->array[i]);
	}
	rsa_values_free(dec);
}

void hex_dump(void * bin, size_t len)
{
	FILE *fp = popen("od -A x -t x1", "w");
	fwrite(bin, 1, len, fp);
	pclose(fp);
}

int main (int argc, char * argv[])
{
	init_rsa();

	int const bits = 1024;
	RSA *rsa = rsa_new_keypair(bits);
	assert(rsa);

	printf("KEYPAIR\n");
	print_rsa(rsa);

	FILE *pub, *prv;
	pub = fopen("pubkey", "w+");
	prv = fopen("prvkey", "w+");
	rsa_save_public(rsa, pub);
	rsa_save_private(rsa, prv);
	rewind(pub);
	rewind(prv);
	rsa_free(&rsa);
	rsa_free(&rsa); /* test for breakage */
	RSA *prvkey = NULL, *pubkey = NULL;
	rsa_load_private(&prvkey, prv);
	pubkey = rsa_load_public(&pubkey, pub);
	printf("\nPRIVATE KEY\n");
	print_rsa(prvkey);
	printf("\nPUBLIC KEY\n");
	print_rsa(pubkey);

	char message[] = "hi there!! :)";
	hex_dump(message, sizeof(message));
	char buf[bits/8];
	assert(rsa_public_encrypt(pubkey, sizeof(message), message, buf) == bits/8);
	hex_dump(buf, sizeof(buf));
	char plain[bits/8];
	assert(rsa_private_decrypt(prvkey, bits/8, buf, plain) == sizeof(message));
	hex_dump(plain, sizeof(plain));
	puts(plain);

	fini_rsa();
	return EXIT_SUCCESS;
}
