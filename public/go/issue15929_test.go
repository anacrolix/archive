package main

import (
	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"net/url"
	"os"
	"sync"
	"testing"
	"time"

	_ "github.com/anacrolix/envpprof"
	"github.com/anacrolix/missinggo"
	"github.com/stretchr/testify/require"
)

func handler(w http.ResponseWriter, r *http.Request) {
	log.Println("got request", r)
	body := []byte("we're done\n")
	w.Header().Set("Content-Length", fmt.Sprint(len(body)))
	w.WriteHeader(200)
	w.(http.Flusher).Flush()
	time.Sleep(2 * time.Second)
	w.Write(body)
}

type acceptOnce struct {
	net.Listener
	mu      sync.Mutex
	accepts int
}

func (me *acceptOnce) Accept() (c net.Conn, err error) {
	c, err = me.Listener.Accept()
	if err != nil {
		return
	}
	me.mu.Lock()
	defer me.mu.Unlock()
	if me.accepts > 0 {
		panic("accepted more than one connection")
	}
	me.accepts++
	return
}

func TestReadTimeoutNextRequest(t *testing.T) {
	c, err := net.Listen("tcp", "localhost:0")
	require.NoError(t, err)
	defer c.Close()
	cert, err := missinggo.NewSelfSignedCertificate()
	require.NoError(t, err)
	s := http.Server{
		ReadTimeout: time.Second,
		Handler:     http.HandlerFunc(handler),
	}
	go func() {
		s.Serve(&acceptOnce{
			// Listener: c,
			Listener: tls.NewListener(c, &tls.Config{
				Certificates: []tls.Certificate{cert},
				NextProtos:   []string{"h2"},
			}),
		})
	}()
	// ctc := httptoo.ClientTLSConfig(http.DefaultClient)
	// ctc.NextProtos = []string{"h2"}
	_cc, err := net.Dial("tcp", c.Addr().String())
	cc := tls.Client(_cc, &tls.Config{
		InsecureSkipVerify: true,
	})
	done := make(chan struct{})
	go func() {
		defer close(done)
		io.Copy(os.Stdout, cc)
	}()
	w := io.MultiWriter(cc, os.Stdout)
	urlStr := (&url.URL{
		Scheme: "http",
		Host:   c.Addr().String(),
	}).String()
	require.NoError(t, err)
	req1, err := http.NewRequest("GET", urlStr, nil)
	require.NoError(t, err)
	err = req1.Write(w)
	require.NoError(t, err)

	time.Sleep(time.Second)

	req2, err := http.NewRequest("GET", urlStr, nil)
	require.NoError(t, err)
	err = req2.Write(w)
	// w.Write([]byte("GET"))
	// io.Copy(os.Stderr, cc)
	// resp1, err := http.Get("http://" + c.Addr().String())
	// require.NoError(t, err)
	// defer resp1.Body.Close()
	// log.Print("getting first response")
	// log.Print(resp1.Proto)
	// resp2, err := http.Get("http://" + c.Addr().String())
	// require.NoError(t, err)
	// defer resp2.Body.Close()
	<-done
}
