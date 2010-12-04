package main

import (
	"crypto/md5"
	"flag"
	"fmt"
	"path"
	"os"
	"runtime"
	"runtime/pprof"
)

func abspath(p string) string {
	base, _ := os.Getwd()
	return path.Clean(path.Join(base, p))
}

type Walker struct {
	paths   chan<- string
	visited map[string]bool
}

func (me Walker) VisitDir(path string, f *os.FileInfo) bool {
	path = abspath(path)
	if !me.visited[path] {
		me.visited[path] = true
		return true
	}
	return false
}

func (me Walker) VisitFile(path string, f *os.FileInfo) {
	abspath := abspath(path)
	if !me.visited[abspath] {
		me.visited[abspath] = true
		me.paths <- path
	}
}

func walkargs(args []string, paths chan<- string) {
	defer close(paths)
	errors := make(chan os.Error)
	defer close(errors)
	var manager Manager
	walker := Walker{paths: paths, visited: make(map[string]bool)}
	for _, arg := range args {
		manager.Go(func(root string) func() {
			return func() {
				fmt.Println(root)
				path.Walk(root, walker, errors)
			}
		}(arg))
	}
	go func() {
		for {
			err := <-errors
			if closed(errors) {
				return
			}
			fmt.Println(err)
		}
	}()
	manager.Wait()
}

type Dupes map[string][]string

func hashfile(name string, dupes Dupes) {
	//fmt.Println("Hashing file:", name)
	file, err := os.Open(name, os.O_RDONLY, 0)
	if file == nil {
		fmt.Println(err)
		return
	}
	defer file.Close()
	hash := md5.New()
	var buf [0x20000]byte
	for {
		n, err := file.Read(buf[:])
		//fmt.Println(name, n, err)
		hash.Write(buf[:n])
		if err == os.EOF {
			break
		} else if n == 0 {
			fmt.Println(err)
			return
		}
	}
	sum := string(hash.Sum())
	dupes[sum] = append(dupes[sum], name)
	fmt.Printf("%x  %v\n", sum, name)
}

func main() {
	fmt.Println("GOMAXPROCS:", runtime.GOMAXPROCS(4))
	flag.Parse()
	paths := make(chan string)
	go walkargs(flag.Args(), paths)
	dupes := make(Dupes)
	var hashmgr Manager
	for {
		name := <-paths
		if closed(paths) {
			break
		}
		hashmgr.Go(func(name string) func() {
			return func() {
				hashfile(name, dupes)
			}
		}(name))
	}
	hashmgr.Wait()
	prof, err := os.Open("finddups.pprof", os.O_WRONLY|os.O_CREAT|os.O_TRUNC, 0666)
	fmt.Println(err)
	pprof.WriteHeapProfile(prof)
}
