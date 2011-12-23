package main

import (
    "flag"
    "os"
    "bencode"
    "log"
)

const block_size = 1 << 14

func newTorrent(metainfo bencode.Dict) *Torrent {
    t := &Torrent{Metainfo: metainfo}
    t.numberOfPieces = uint(len(t.Metainfo["info"].(bencode.Dict)["pieces"].(string)) / 20)
    url :=
    t.trackers = append(t.trackers, newTracker(metainfo["announce"].(string)))
    announce_list := metainfo["announce-list"].(bencode.List)
    for _, tier_list := range announce_list {
        for _, url := range tier_list.(bencode.List) {
            t.trackers = append(t.trackers, newTracker(url.(string)))
        }
    }
    return t
}

type block struct {
    begin, length int
}

type Torrent struct {
    Metainfo bencode.Dict
    wanted [][]uint
    numberOfPieces uint
    blocksPerPiece uint
    trackers map[string]Tracker
    infoHash [20]byte
    peerId [20]byte
}

func (t Torrent) Run() {
    for _, track := range t.trackers {
        track.Announce(t)
    }
}

func (t *Torrent) InfoHash() []byte {
    return t.infoHash[:]
}

func (t *Torrent) PeerId() []byte {
    return t.peerId[:]
}

func (t *Torrent) Uploaded() int {
    return 0
}

func (t *Torrent) Downloaded() int {
    return 0
}

func (t *Torrent) Left() int {
    return 0
}

func (t *Torrent) Port() int {
    return 0
}

func AddTracker(url string) bool {


func main() {
    flag.Parse()
    torrent_file, err := os.Open(flag.Arg(0))
    if err != nil {
        log.Fatal(err)
    }
    metainfo, err := bencode.Decode(torrent_file)
    if _, ok := metainfo.(bencode.Dict); !ok {
        log.Fatal("Invalid torrent file")
    }
    torrent := newTorrent(metainfo.(bencode.Dict))
    println(torrent.numberOfPieces)
    torrent.Run()
}
