package main

//import "flag"
import "fmt"
//import "math"
import "os"
import "runtime"
import "strconv"

type prime uint

func generate(out chan prime) {
    for i := prime(2); ; i++ {
        out <- i
    }
}

func filter(in, out chan prime, q prime) {
    for {
        p := <-in
        if p % q != 0 {
            out <- p
        }
    }
}

const bufsize = 0

func primes(out chan prime, n prime) {
    in := make(chan prime, bufsize)
    go generate(in)
    for {
        p := <-in
        if p > n {
            close(out)
            break
        }
        out <- p
        ch := make(chan prime, bufsize)
        go filter(in, ch, p)
        in = ch
    }
}

func main() {
    fmt.Fprintln(os.Stderr, "Using", runtime.GOMAXPROCS(4), "threads")
    n, _ := strconv.Atoui(os.Args[1])
    ch := make(chan prime, bufsize)
    go primes(ch, prime(n))
    for {
        p := <-ch
        if closed(ch) {
            return
        }
        fmt.Println(p)
    }
}
