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
    //~ println(url)
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
            //~ println(lp.Rank, lp.Lang)
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
