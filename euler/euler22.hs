module Main where

main :: IO ()
main = putStr (show (sum [ sumPairs x (sumOfDivs x) | x <- [1..1000]]))

-- Paarid, mille jagajate summa on võrdne teise arvuga ja teise arvu
-- jagajate summa on võrdne esimese arvuga.

-- Täisarvu jagajad
divisors :: Int->[Int]
divisors n = [ x | x <- [1..(n `div` 2)], (n `mod` x) == 0 ]

-- Jagajate summa
sumOfDivs :: Int->Int
sumOfDivs n = sum [ x+(n `div` x) | x <- [2..ceiling (sqrt (fromIntegral n))], (n `mod` x) == 0 ] +1

-- Paari kontrollija, ver 2
checkPair2 :: Int->Int->Int->Bool
checkPair2 x s y = (x == (sumOfDivs y)) && (y == s)

-- Antud arvus ja 1..arv paaride summa
sumPairs :: Int->Int->Int
sumPairs n sd = sum [ x+n | x <- [1..n-1], checkPair2 n sd x ]