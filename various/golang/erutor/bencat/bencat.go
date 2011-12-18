package main

import (
    "bencode"
    "flag"
    "strconv"
    "os"
    "fmt"
)

func main() {
    flag.Parse()
    val, err := bencode.Decode(os.Stdin)
    if err != nil {
        panic(err)
    }
    for _, arg := range flag.Args() {
        fmt.Println(arg)
        switch val.(type) {
        case bencode.List:
            i, err := strconv.Atoui(arg)
            if err != nil {
                panic(err)
            }
            val = val.(bencode.List)[i]
        case bencode.Dict:
            val = val.(bencode.Dict)[arg]
        default:
            panic(val)
        }
    }
    fmt.Println(val)
}
