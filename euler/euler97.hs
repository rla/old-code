aste :: Integer
aste = 7830457

astenda_mod :: Integer -> Integer -> Integer -> Integer
astenda_mod arv 0 _ = 1
astenda_mod arv aste m | (odd aste) = (arv * (astenda_mod arv (aste - 1) m)) `mod` m 
                       | otherwise = ((astenda_mod arv (aste `div` 2) m) ^ 2) `mod` m

lahendus = (28433 * (astenda_mod 2 aste (10^10)) + 1) `mod` 10^10