#!/usr/bin/env runhaskell

import Prelude hiding (filter)
import Control.Monad
import Control.Concurrent.Chan
import Control.Concurrent

filter in_ out prime = forever $ do
    n <- readChan in_
    case n `mod` prime of
        0 -> return ()
        _ -> writeChan out n

generate ch max = do
    mapM_ (writeChan ch) $ enumFromTo 2 max

sieve ch = do
    prime <- readChan ch
    print prime
    ch1 <- newChan
    forkIO $ filter ch ch1 prime
    sieve ch1

main = do
    ch <- newChan
    forkIO $ generate ch 10000
    sieve ch
