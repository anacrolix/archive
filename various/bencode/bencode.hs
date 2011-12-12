#!/usr/bin/env runhaskell

import qualified Data.ByteString as B
import System.IO
import Data.Map as Map

type Dict = Map.Map String Data

data Data = Dict | List | Number | String

decodeDict :: Dict -> String -> (Dict, String)
decodeDict d (k:a:s) = decodeDict (Map.insert k a d) s
decodeDict d [] = d

decode :: String -> [Data]
decode [] = []
decode (c:s) = case c of
    'd' -> decodeDict Map.empty s
    'e' -> []

main = decode stdin >>= print . head
