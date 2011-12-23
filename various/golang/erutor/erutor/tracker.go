package main

import (
    "url"
    "strconv"
    "http"
    "io/ioutil"
    "os"
)

const (
    noneEvent = 0
    completedEvent = 1
    startedEvent = 2
    stoppedEvent = 3
)

type Tracker interface {
    Announce(Torrent) ([]string, int, os.Error)
}

type udpTracker struct {
    host string
    path string
}

func (t udpTracker) Announce(Torrent) (peers []string, interval int, err os.Error) {
    return
}

type httpTracker struct {
    url string
}

func (h *httpTracker) Announce(t Torrent) (peers []string, interval int, err os.Error) {
    query := url.Values{
        "info_hash": []string{string(t.InfoHash()[:])},
        "peer_id": {string(t.PeerId())},
        "port": {strconv.Itoa(t.Port())},
        "uploaded": {strconv.Itoa(t.Uploaded())},
        "downloaded": {strconv.Itoa(t.Downloaded())},
        "left": {strconv.Itoa(t.Left())},
        "compact": {"1"},
        "no_peer_id": {"1"},
    }
    url, err := url.Parse(h.url)
    if err != nil {
        panic(err)
    }
    url.RawQuery = query.Encode()
    rawurl := url.String()
    var resp *http.Response
    resp, err = http.Get(rawurl)
    if err != nil {
        return
    }
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        panic(err)
    }
    peers = append(peers, string(body))
    return
}

func newTracker(rawurl string) Tracker {
    url, err := url.Parse(rawurl)
    if err != nil {
        panic(err)
    }
    switch url.Scheme {
    case "http":
        return &httpTracker{url: rawurl}
    case "udp":
        return &udpTracker{}
    default:
        panic(rawurl)
    }
    return nil
}
