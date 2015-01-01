module Euler where

qsort :: [Integer] -> [Integer]
qsort [] = []
qsort (x:xs) = (qsort [ y | y <- xs, y <= x ]) ++ [x] ++ (qsort [ y | y <- xs, y > x])

removeDuplicates :: [Integer] -> [Integer]
removeDuplicates [] = []
removeDuplicates (x:xs) = removeDuplicates' x xs
  where
    removeDuplicates' x [] = [x]
    removeDuplicates' x (y:ys) | x == y = removeDuplicates' x ys
                               | otherwise = x:(removeDuplicates' y ys)

euler = (length.removeDuplicates.qsort) [ a^b | a <- [2..100], b <- [2..100] ]
