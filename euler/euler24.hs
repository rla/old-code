module Euler where

fact :: Int -> Int
fact 0 = 1
fact n = product [1..n]

lexpermut :: Char -> [[Char]] -> [[Char]]
lexpermut c xss = [ c:xs | xs <- xss]

ccomb :: Char -> [Char] -> [Char] -> [Char]
ccomb c start end = start ++ (c:end)

ccombs :: Char -> [Char] -> [[Char]]
ccombs c cs = [ ccomb c (take i cs) (drop (i+1) cs) |  ]
