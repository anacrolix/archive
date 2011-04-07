package main

//import "flag"
import "fmt"
import "math"
import "os"
import "runtime"
import "strconv"

type prime uint

//const bufsize = 1000

func primes(n prime) {
    var primes []prime
    for p := prime(2); p <= n; p++ {
        s := prime(math.Sqrt(float64(p)))
        isprime := true
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
            fmt.Println(p)
            primes = append(primes, p)
        }
    }
}

func main() {
    fmt.Fprintln(os.Stderr, "Using", runtime.GOMAXPROCS(4), "threads")
    n, _ := strconv.Atoui(os.Args[1])
    //ch := make(chan prime, bufsize)
    primes(prime(n))
}
