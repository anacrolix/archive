#!/usr/bin/env runhaskell

import Control.Monad
import Control.Concurrent

-- This synonym makes it easy to switch from Int to Integer
type N = Int

data Msg = Sieve N | Stop
    deriving (Show)

type Get = IO Msg
type Put = Msg -> IO ()

newPair :: IO (Put, Get)
newPair = do
    c <- newChan
    return (writeChan c, readChan c)

sieve :: Get -> Put -> N -> IO ()
sieve get put p = go where
    pDivides n = n `mod` p == 0
    go = get >>= act
    act Stop = put Stop
    act msg@(Sieve n)
        | pDivides n = go
        | otherwise  = put msg >> go

build :: Get -> IO ()
build get = get >>= act where
    act Stop = return ()
    act (Sieve prime) = do
        print prime
        (newPut, newGet) <- newPair
        forkIO $ sieve get newPut prime
        build newGet

main :: IO ()
main = do
    (put, get) <- newPair
    forkIO $ do
        forM_ [2..10000] (put . Sieve)
        put Stop
    build get
