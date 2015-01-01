module Main where

-- Arvud, mis on võrdsed nende numbrite viiendate astemete summaga

-- Kontrollime, kas arv vastab antud tingimustele
checkNum :: Int->Bool
checkNum n = (sum [ x^5 | x <- (digits n) ]) == n

-- Täisarvu teisendamine numbrite listiks
digits :: Int->[Int]
digits 0 = []
digits n = (n `mod` 10): digits (n `div` 10)