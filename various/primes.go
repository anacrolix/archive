package main

//import "flag"
import "fmt"
import "math"
import "os"
import "runtime"
import "strconv"

type prime uint

func generate(out chan prime) {
    out <- 2
    out <- 3
    for i := 6; ; i += 6 {
        out <- prime(i - 1)
        out <- prime(i + 1)
    }
}

func filter(in, out chan prime, n prime) {
    var primes []prime
    for {
        p := <-in
        if p > n {
            close(out)
            return
        }
        isprime := true
        s := prime(math.Sqrt(float64(p)))
        for _, q := range primes {
            if q > s {
                break
            }
            if p % q == 0 {
                isprime = false
                break
            }
        }
        if isprime {
            out <- p
            primes = append(primes, p)
        }
    }
}

func main() {
    n, _ := strconv.Atoui(os.Args[1])
    cands := make(chan prime, 100)
    go generate(cands)
    primes := make(chan prime, 100)
    go filter(cands, primes, prime(n))
    println(runtime.GOMAXPROCS(4))
    for {
        p := <-primes
        if closed(primes) {
            return
        }
        fmt.Println(p)
    }
}

//#include <math.h>
//#include <stdbool.h>
//#include <stdio.h>
//#include <stdlib.h>

//typedef int Prime;

//static bool is_prime(Prime p, Prime *primes, size_t prime_count)
//{
    //for (size_t i = 2; i < prime_count; ++i) {
        //Prime q = primes[i];
        //if (q*q > p) break;
        //if (p % q == 0) return false;
    //}
    //return true;
//}

//static void next_prime(Prime p, Prime *primes, size_t *prime_count)
//{
    //if (is_prime(p, primes, *prime_count)) {
        //primes[*prime_count] = p;
        //*prime_count += 1;
    //}
//}

//int main(int argc, char *argv[])
//{
    //Prime const n = atol(argv[1]);
    //size_t const max_primes = (1.25506 * n) / log(n) + 1;
    //Prime *const primes = malloc(max_primes * sizeof(Prime));
    //size_t prime_count = 0;
    //if (2 <= n) next_prime(2, primes, &prime_count);
    //if (3 <= n) next_prime(3, primes, &prime_count);
    //for (Prime p = 6; p <= n; p += 6) {
        //next_prime(p - 1, primes, &prime_count);
        //next_prime(p + 1, primes, &prime_count);
    //}
    //for (size_t i = 0; i < prime_count; ++i) {
        //printf("%d\n", primes[i]);
    //}
    //return 1;
//}
