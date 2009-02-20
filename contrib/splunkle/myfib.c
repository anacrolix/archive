#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

intmax_t fib(int, intmax_t, intmax_t);

int main(int argc, char *argv[])
{
	const char *usage = "Takes one argument, n.  Outputs the nth number in the fibb sequence";
	intmax_t value;
	int n = atoi(argv[1]);
	if (n<0) {
		printf(usage);
		exit(EXIT_FAILURE);
	} else if (n == 0) {
		value = 1;
	} else if (n == 1) {
		value = 1;
	} else {
		value = fib(n, 1, 1);
	}
	printf("%d/n", value);
	return EXIT_SUCCESS;
}

intmax_t fib(int n, intmax_t x, intmax_t y)
{
	if (n == 1) {
		return y;
	} else {
		return fib(n-1, y, x+y);
	}
}

/*In Haskell, this is easier:

fibb :: Integer->Integer
fibb 0 = 1
fibb 1 = 1
fibb n = fib n 1 1

fib :: Integer->Integer->Integer
fib 1 _ y = y
fib n x y = fib (n-1) y (x+y)

And just as fast, so long as the compiler
recognises this is tail recursion.*/
