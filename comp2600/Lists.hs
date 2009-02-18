 
-- Some list functions that are declared in the standard prelude --
 
head             :: [a] -> a
head (x:_)        = x
 
last             :: [a] -> a
last [x]          = x
last (_:xs)       = last xs
 
tail             :: [a] -> [a]
tail (_:xs)       = xs
 
init             :: [a] -> [a]
init [x]          = []
init (x:xs)       = x : init xs
 
null             :: [a] -> Bool
null []           = True
null (_:_)        = False
 
(++)             :: [a] -> [a] -> [a]
[]     ++ ys      = ys
(x:xs) ++ ys      = x : (xs ++ ys)
 
map              :: (a -> b) -> [a] -> [b]
map f xs          = [ f x | x <- xs ]
 
filter           :: (a -> Bool) -> [a] -> [a]
filter p xs       = [ x | x <- xs, p x ]

concat           :: [[a]] -> [a]
concat []         = []
concat (x:xs)     = x ++ concat xs
 
length           :: [a] -> Int
length []         = 0
length (x:xs)     = length xs + 1
 
(!!)             :: [b] -> Int -> b
(x:_)  !! 0       = x
(_:xs) !! n | n>0 = xs !! (n-1)
(_:_)  !! _       = error "Prelude.!!: negative index"
[]     !! _       = error "Prelude.!!: index too large"
 
take                :: Int -> [a] -> [a]
take 0 _             = []
take _ []            = []
take n (x:xs) | n>0  = x : take (n-1) xs
take _ _             = error "Prelude.take: negative argument"
 
drop                :: Int -> [a] -> [a]
drop 0 xs            = xs
drop _ []            = []
drop n (_:xs) | n>0  = drop (n-1) xs
drop _ _             = error "Prelude.drop: negative argument"
 
reverse       :: [a] -> [a]
reverse []     = []
reverse (x:xs) = reverse xs ++ [x]
 
and, or       :: [Bool] -> Bool
and []         = True
and (x:xs)     = x && and xs
or []          = False
or (x:xs)      = x || or xs
 
any, all      :: (a -> Bool) -> [a] -> Bool
any p          = or  . map p
all p          = and . map p
 
elem, notElem    :: Eq a => a -> [a] -> Bool
elem              = any . (==)
notElem           = all . (/=)
 
sum, product     :: Num a => [a] -> a
sum []            = 0
sum (x:xs)        = x + sum xs
product []        = 1
product (x:xs)    = x * product xs
 
maximum, minimum :: Ord a => [a] -> a
maximum [x]       = x
maximum (x:xs)    = max x (maximum xs)
minimum [x]       = x
minimum (x:xs)    = min x (minimum xs)
 
zip              :: [a] -> [b] -> [(a,b)]
zip [] _          = []
zip _ []          = []
 
unzip            :: [(a,b)] -> ([a],[b])
unzip             = foldr (\(a,b) ~(as,bs) -> (a:as, b:bs)) ([], [])
 
repeat           :: a -> [a]
repeat x          = xs where xs = x:xs
 
replicate        :: Int -> a -> [a]
replicate n x     = take n (repeat x)
