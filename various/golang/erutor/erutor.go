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
    t.NumberOfPieces = len(t.Metainfo["info"].(bencode.Dict)["pieces"].(string)) / 20
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
    println(torrent.NumberOfPieces)
    torrent.Run()
}
