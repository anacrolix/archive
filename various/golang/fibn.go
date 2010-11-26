package main

import "flag"
import "fmt"
import "os"
import "strconv"

func main() {
    flag.Parse()
    if flag.NArg() != 1 {
        os.Exit(2)
    }
    count, err := strconv.Atoi(flag.Arg(0))
    if (err != nil) {
        os.Exit(2)
    }
    fmt.Println(fib(uint64(count)))
}

func fib(n uint64) []uint64 {
    retval := make([]uint64, n)
    var a, b uint64 = 0, 1
    for i := range(retval) {
        retval[i] = a
        c := a + b
        a = b
        b = c
    }
    return retval
}
