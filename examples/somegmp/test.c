#include <gmp.h>
#include "../eruutil/erudebug.h"

int main()
{
	dump(__GNU_MP_VERSION, "%d");
	dump(__GNU_MP_VERSION_MINOR, "%d");
	dump(__GNU_MP_VERSION_PATCHLEVEL, "%d");
	dump(mp_bits_per_limb, "%d");
	dump(gmp_version, "%s");
	mpz_t a; //mpq_t mpf_t
	mpz_init(a);
	mpz_set_ui(a, 0);
	mpz_add_ui(a, a, 17);
	char *str = mpz_get_str(NULL, 10, a);
	puts(str);
	mpz_clear(a);
	return 0;
}
