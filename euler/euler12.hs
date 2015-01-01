module Main where
import Primality

-- Leida esimene arv kujul (1+2+3+4..), millel on üle
-- 500 teguri.

-- Arvu tegurite arv
factors :: Int->Int
factors n = length [ x | x <- [1..floor (sqrt (fromIntegral n))], (n `mod` x) == 0 ]

facts :: Int->[Int]
facts n = [ x | x <- [1..n], (n `mod` x) == 0 ]

-- Jada summa ja tegurite pidev leidmine
triangleFactors :: Int->[Int]
triangleFactors n = (factors n):triangleFactors (n+1)