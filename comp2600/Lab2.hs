noobList :: [Int]
noobList = [1, 2, 3, 4]

rotateL :: [a] -> [a]
rotateL [] = []
rotateL x = last x : init x

rotateR :: [a] -> [a]
rotateR [] = []
rotateR x = tail x ++ [head x]

prune :: [Int] -> [Int] -> [Int]
prune xs ys = [x | x <- xs, x `notElem` ys]

passes :: [(String,Integer)] -> [String]
passes students = [name | (name,mark) <- students, (>=) mark 50]

getStudMark :: String -> [(String,Int)] -> Int
getStudMark _ [] = error "Student not found"
getStudMark [] _ = error "Student name must be specified"
getStudMark s ((name,mark):xs) = 
   if s == name then mark
   else getStudMark s xs

list1 :: [Int]
list1 = [1, 2, 3, 4, 5]

list2 :: [Int]
list2 = [6, 7, 8, 9, 10]

equivMod2 :: [Int] -> [Int] -> Bool
equivMod2 as bs = 
   (length as == length bs) && --same length
   and (zipWith (==) (map even as) (map even bs))
