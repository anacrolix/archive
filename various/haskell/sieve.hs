#!/usr/bin/env runhaskell

import Prelude hiding (filter)
import Control.Monad
import Control.Concurrent.Chan
import Control.Concurrent

filter in_ out prime = do
    value <- readChan in_
    case value of
        Nothing -> writeChan out Nothing
        Just n -> do
            case n `mod` prime of
                0 -> return ()
                _ -> writeChan out (Just n)
            filter in_ out prime

generate ch max = do
    mapM_ (writeChan ch . Just) $ enumFromTo 2 max
    writeChan ch Nothing

sieve ch = do
    value <- readChan ch
    case value of
        Nothing -> return ()
        Just prime -> do
            print prime
            ch1 <- newChan
            forkIO $ filter ch ch1 prime
            sieve ch1

main = do
    ch <- newChan
    forkIO $ generate ch 100
    sieve ch
