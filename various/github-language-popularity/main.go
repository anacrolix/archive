package main

import (
	"http"
	"io/ioutil"
	"regexp"
    "url"
    "strconv"
)

var langre = regexp.MustCompile("/languages/([^/\"]+)")

func languages() (langs []string) {
	resp, err := http.Get("http://github.com/languages")
	if err != nil {
		panic(err)
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		panic(err)
	}
    seen := make(map[string]bool)
	for _, subm := range langre.FindAllStringSubmatch(string(body), -1) {
        unlang, err := url.QueryUnescape(subm[1])
        if err != nil { panic(err) }
        if !seen[unlang] {
            seen[unlang] = true
            langs = append(langs, subm[1])
        }
	}
    return
}

var rankre = regexp.MustCompile("is the #([0-9]+)")
var mostpop = regexp.MustCompile("is <strong>the most")

func popularity(lang string) int {
    url := "http://github.com/languages/" + lang
    println(url)
    resp, err := http.Get(url)
    if err != nil {panic(err)}
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        panic(err)
    }
    subm := rankre.FindSubmatch(body)
    if subm == nil {
        if mostpop.Find(body) != nil {
            return 1
        }
        return 0
    }
    rank, err := strconv.Atoi(string(subm[1]))
    if err != nil {panic(err)}
    return rank
}

type langpop struct { Lang string; Rank int }

func main() {
    rankch := make(chan langpop)
    nlangs := 0
	for _, lang := range languages() {
		go func(lang string) {
            rankch<-langpop{lang, popularity(lang)}
        }(lang)
        nlangs++
	}
    ranks := make(map[int]string)
    for r := 1; ; r++ {
        for {
            if _, ok := ranks[r]; ok {
                break
            } else if nlangs == 0 {
                return
            }
            lp := <-rankch
            println(lp.Rank, lp.Lang)
            ranks[lp.Rank] = lp.Lang
            nlangs--
        }
        plang, err := url.QueryUnescape(ranks[r])
        if err != nil {
            panic(err)
        }
        println(r, plang)
    }
}

/*
#!/usr/bin/env python3.2

import logging, urllib.request, urllib.parse, re, concurrent.futures, itertools

def language_popularity(lang):
    qlang = urllib.parse.quote(lang)
    try:
        sub = urllib.request.urlopen("http://github.com/languages/" + qlang).read()
    except:
        logging.exception('Error fetching %r', lang)
        return
    match = re.search(b'is the #(\\d+)', sub)
    if match:
        rank = int(match.group(1))
    else:
        rank = 1
    return rank, lang

def languages():
    for match in re.finditer(b'/languages/([^/]+?)"', urllib.request.urlopen('http://github.com/languages').read()):
        yield urllib.parse.unquote(match.group(1).decode())

def main():
    futures = []
    with concurrent.futures.ThreadPoolExecutor(45) as pool:
        for lang in languages():
            futures.append(pool.submit(language_popularity, lang))
        ranks = {}
        completed = concurrent.futures.as_completed(futures)
        for rank in itertools.count(1):
            while rank not in ranks:
                try:
                    result = next(completed).result()
                except StopIteration:
                    break
                if result is None:
                    continue
                new_rank, lang = result
                ranks[new_rank] = lang
            if rank not in ranks:
                break
            print(rank, ranks[rank])
        for rank1 in sorted(r for r in ranks if r >= rank):
            print(rank1, ranks[rank1])

if __name__ == '__main__':
    main()
*/
