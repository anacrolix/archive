package main

import (
    "url"
)

const (
    noneEvent = 0
    completedEvent = 1
    startedEvent = 2
    stoppedEvent = 3
)

type Tracker interface {
    Announce()
}

type udpTracker struct {
    host string
    path string
}

func (t udpTracker) Announce() {
}

type httpTracker struct {
    url string
}

func (t httpTracker) Announce() {
}

func newTracker(rawurl string) Tracker {
    url, err := url.Parse(rawurl)
    if err != nil {
        panic(err)
    }
    switch url.Scheme {
    case "http":
        return httpTracker{}
    case "udp":
        return udpTracker{}
    default:
        panic(rawurl)
    }
    return nil
}
