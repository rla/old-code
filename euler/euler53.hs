module Euler where

fact :: Integer -> Integer
fact 0 = 1
fact n = n * (fact (n-1))

euler = length [ x | x <- [ (fact n) `div` ((fact r) * (fact (n-r))) | n <- [1..100], r <- [0..n] ], x > 1000000 ]
