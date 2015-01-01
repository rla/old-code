module Euler where

sumOfDigits :: Integer -> Integer
sumOfDigits 0 = 0
sumOfDigits n = (n `mod` 10) + (sumOfDigits (n `div` 10))

euler = maximum [ sumOfDigits (a^b) | a <- [1..99], b <- [1..99] ]
