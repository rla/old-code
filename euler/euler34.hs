module Euler34 where

-- Täisarvu teisendamine numbrite listiks
digits :: Int->[Int]
digits 0 = []
digits n = (n `mod` 10): digits (n `div` 10)

-- Faktoriaali leidmine
fact :: Int->Int
fact n | n>1 = n*fact (n-1)
       | otherwise = 1

-- Numbrite listi numbrite faktoriaalide summa leidmine
sumfacts :: [Int]->Int
sumfacts xs = sum [ fact n | n <- xs ]

-- [ n | n<-[3..200000], sumfacts (digits n) == n ]
-- Annab vastuse kui summa võtta!