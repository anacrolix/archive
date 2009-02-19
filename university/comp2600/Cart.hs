cart :: [[a]] -> [[a]]
cart [[]] = [[]]
cart (x:xs)
 | length x == 1 && length xs == 0 = [[head x]]
 | length x == 1 && length xs > 0 = map ((head x):) (cart xs)
 | length x > 1 && length xs == 0 = [head x]:(cart [tail x])
 | length x > 1 && length xs > 0 = cart ([[head x]] ++ xs) ++ cart ([tail x] ++ xs)