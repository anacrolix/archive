package bencode

import (
    "io"
    "os"
    "strconv"
)

var e = new(interface{})
type List []interface{}
type Dict map[string]interface{}

func Decode(r io.Reader) (interface{}, os.Error) {
    var t [1]byte
    n, err := r.Read(t[:])
    if n != 1 {
        return nil, err
    }
    switch c := t[0]; {
    case c == 'd':
        val := make(Dict)
        for {
            k, _ := Decode(r)
            if k == e {
                break
            }
            v, _ := Decode(r)
            val[k.(string)] = v
        }
        return val, nil
    case c == 'l':
        val := List{}
        for {
            i, _ := Decode(r)
            if i == e {
                break
            }
            val = append(val, i)
        }
        return val, nil
    case c == 'e':
        return e, nil
    case c == 'i':
        s := []byte{}
        for {
            c := make([]byte, 1)
            if n, err := r.Read(c); n != 1 {
                return nil, err
            }
            if c[0] == 'e' {
                break
            }
            s = append(s, c[0])
        }
        i, err := strconv.Atoi(string(s))
        if err != nil {
            return nil, err
        }
        return i, nil
    case '0' <= c && c <= '9':
        s := []byte{c}
        for {
            c := make([]byte, 1)
            _, err := r.Read(c)
            if err != nil {
                return nil, err
            }
            if c[0] == ':' {
                break
            }
            s = append(s, c[0])
        }
        len, err := strconv.Atoi(string(s))
        if err != nil {
            return nil, err
        }
        val := make([]byte, len)
        if n, err := r.Read(val); n != len {
            return nil, err
        }
        return string(val), nil
    default:
        panic("unhandled type: " + string(t[:]))
    }
    panic("shouldn't be here")
}

func Encode(w io.Writer) {
}
