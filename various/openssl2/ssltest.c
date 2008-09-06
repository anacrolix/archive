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

int main (int argc, char * argv[])
{
	init_rsa();

	RSA *rsa = rsa_new_keypair(1024);
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
	prvkey = rsa_load_private(NULL, prv);
	pubkey = rsa_load_public(&pubkey, pub);
	printf("\nPRIVATE KEY\n");
	print_rsa(prvkey);
	printf("\nPUBLIC KEY\n");
	print_rsa(pubkey);

	fini_rsa();
	return EXIT_SUCCESS;
}
