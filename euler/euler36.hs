module Main where

-- Arvud alla miljoni, mis on palindroomid kümnend ja kahendüsteemis

main :: IO ()
main = putStr (show (sum [ x | x <- [1..1000000], isPalindrome x int2bin, isPalindrome x int2arv]))

-- Täisarvu teisendamine Arvuks
int2arv :: Int->[Int]
int2arv 0 = []
int2arv n = (n `mod` 10): int2arv (n `div` 10)

isPalindrome' :: [Int]->[Int]->Int->Bool
isPalindrome' xs sx n = (take n xs)==(take n sx)

isPalindrome :: Int->(Int->[Int])->Bool
isPalindrome n f = isPalindrome' arv vra (div (length arv) 2)
  where
    arv = f n
    vra = reverse arv  
    
-- Täisarvu konvertimine kahendarvuks (list ühtedest ja nullidest)
int2bin :: Int->[Int]
int2bin 0 = []
int2bin n = (n `mod` 2): int2bin (n `div` 2)