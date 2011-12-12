package main

import (
    "io"
    "os"
)

type Data interface {}

func Decode(r io.Reader) (out chan Data) {
    out = make(chan Data)
    go func() {
        for {
            var c [1]byte
            n, _ := r.Read(c[:])
            if n == 0 {
                return
            }
            switch c[0] {
            case 'd':
                var dict map[string]Data
                sub := Decode(r)
                for {
                    key := (<-sub).(string)
                    value := <-sub
                    dict[key] = value
                }
                out<-dict
            case 'l':
                l := make([]Data, 0)
                sub := Decode(r)
                for {
                    val := <-sub
                    l = append(l, val)
                }
                out <- l
            }
        }
    }()
    return
}

func main() {
    print(<-Decode(os.Stdin))
}

/*
def decode(f):
    while True:
        c = f.read(1).decode()
        if not c:
            return
        if c == 'd':
            a = iter(decode(f))
            yield collections.OrderedDict(zip(map(bytes.decode, a), a))
        elif c == 'i':
            i = ''
            while True:
                c = f.read(1).decode()
                if not c:
                    return
                if c == 'e':
                    yield int(i)
                    break
                else:
                    i += c
        elif c == 'l':
            yield list(decode(f))
        elif c == 'e':
            return
        else:
            i = c
            while True:
                c = f.read(1).decode()
                assert c, ('Unterminated key:', i)
                if c == ':':
                    yield f.read(int(i))
                    break
                else:
                    i += c
*/
