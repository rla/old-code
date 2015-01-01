module Euler52 where

-- Täisarvu teisendamine numbrite listiks
digits :: Int->[Int]
digits 0 = []
digits n = (n `mod` 10): digits (n `div` 10)

-- Numbri olemasolu kontroll arvus
isin :: Int->[Int]->Bool
isin n xs = or [ True | x<-xs, x==n ]

-- Kas kaks arvu sisaldavad samu numbreid?
samedigits :: Int->Int->Bool
samedigits x y = and [ isin nx ys  | nx<-digits x ]
  where ys=digits y