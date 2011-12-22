package main

import (
    "flag"
    "os"
    "bencode"
    "log"
)

const block_size = 1 << 14

func newTorrent(metainfo bencode.Dict) *torrent {
    t := &torrent{Metainfo: metainfo}
    t.numberOfPieces = uint(len(t.Metainfo["info"].(bencode.Dict)["pieces"].(string)) / 20)
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

type torrent struct {
    Metainfo bencode.Dict
    wanted [][]uint
    numberOfPieces uint
    blocksPerPiece uint
    trackers []Tracker
}

func (t torrent) Run() {
}

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
