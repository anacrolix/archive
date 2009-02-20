static inline __attribute__((always_inline)) __attribute__((pure)) __attribute__((deprecated)) int 
imax (int a, int b)
{
	return (a > b) ? a : b;
}

int main (int __attribute__((unused)) argc, __attribute__ ((unused)) char *argv[])
{
	imax(1, 2);
	if (__builtin_expect(!!(1), 0)) {
	} else {}
	return 0;
}
