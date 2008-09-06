#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

#include "minrsa.h"

int main (int argc, char * argv[])
{
	init_rsa();
	RSA *rsa = rsa_new_keypair(1024);
	assert(rsa);
	rsa_vals_sz *dec = rsa_values_dec(rsa);
	for (int i = 0; i < 8; i++) {
		printf("%s\n", dec->array[i]);
	}
	rsa_values_free(dec);
	fini_rsa();
	return EXIT_SUCCESS;
}
