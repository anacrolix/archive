c :: (Int, Int) -> Int
c (m, n)
  | n == 0 || n == m = 1
  | n > 0 && n < m = c (m-1, n-1) + c (m-1, n)
  | otherwise = 0

next_row :: [Int] -> [Int]
next_row [] = []
next_row x = [head x] ++ (zipWith (+) (init x) (tail x)) ++ [last x]

row_n :: Int -> [Int]
row_n 0 = [1]
row_n x = next_row (row_n (x-1))