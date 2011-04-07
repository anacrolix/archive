#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef int Prime;

static bool is_prime(Prime p, Prime *primes, size_t prime_count)
{
    for (size_t i = 2; i < prime_count; ++i) {
        Prime q = primes[i];
        if (q*q > p) break;
        if (p % q == 0) return false;
    }
    return true;
}

static void next_prime(Prime p, Prime *primes, size_t *prime_count)
{
    if (is_prime(p, primes, *prime_count)) {
        primes[*prime_count] = p;
        *prime_count += 1;
    }
}

int main(int argc, char *argv[])
{
    Prime const n = atol(argv[1]);
    size_t const max_primes = (1.25506 * n) / log(n) + 1;
    Prime *const primes = malloc(max_primes * sizeof(Prime));
    size_t prime_count = 0;
    if (2 <= n) next_prime(2, primes, &prime_count);
    if (3 <= n) next_prime(3, primes, &prime_count);
    for (Prime p = 6; p <= n; p += 6) {
        next_prime(p - 1, primes, &prime_count);
        next_prime(p + 1, primes, &prime_count);
    }
    for (size_t i = 0; i < prime_count; ++i) {
        printf("%d\n", primes[i]);
    }
    return 1;
}
