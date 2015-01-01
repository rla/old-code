module Main where

--main :: IO ()
--main = putStr (show (euler48 1000))

-- Arv numbrite listina
type Arv=[Int]

num :: Char->Int
num ch | ch=='0' = 0
       | ch=='1' = 1
       | ch=='2' = 2
       | ch=='3' = 3
       | ch=='4' = 4
       | ch=='5' = 5
       | ch=='6' = 6
       | ch=='7' = 7
       | ch=='8' = 8
       | ch=='9' = 9
       
charnum :: Int->Char
charnum num | num==0 = '0'
            | num==1 = '1'
            | num==2 = '2'
            | num==3 = '3'
            | num==4 = '4'
            | num==5 = '5'
            | num==6 = '6'
            | num==7 = '7'
            | num==8 = '8'
            | num==9 = '9'
       
-- Sõne teisendamine arvuks, "2000" => [0,0,0,2]
str2arv :: String->Arv
str2arv str = reverse [ num ch | ch <- str ]

-- Arvu teisendamine sõneks, [0,0,0,2] => "2000"
arv2str :: Arv->String
arv2str [] = ""
arv2str ar = [ charnum x | x <-(dropWhile (==0) (reverse ar)) ]

-- Kahe arvu korrutis
multArv :: Int->Arv->Arv->[Arv]
multArv offset [] ys = [] -- baasjuhtum
multArv offset (x:xs) ys = ((take offset (repeat 0)) ++ (multint 0 x ys)): (multArv (offset+1) xs ys)

-- Korrutise wrapper
mult :: Arv->Arv->Arv
mult x y = addArvList (multArv 0 x y)

-- Liitmise wrapper
add :: Arv->Arv->Arv
add x y = addArv 0 x y

-- Kahe arvu liitmine
addArv :: Int->Arv->Arv->Arv
--addArv j [x] [y] = ((j+y+x) `mod` 10): [((j+y+x) `div` 10)]
--addArv j [] (y:ys) = ((j+y) `mod` 10):(addArv j ys [])
--addArv 0 [] ys = ys
--addArv 0 xs [] = xs
--addArv j (x:xs) [] = ((j+x) `mod` 10):(addArv j xs [])

addArv j [] [] = if (j/=0) then [j] else []
addArv j [] (y:ys) = ((j+y) `mod` 10): (addArv ((j+y) `div` 10) ys [])
addArv j (x:xs) [] = ((j+x) `mod` 10): (addArv ((j+x) `div` 10) xs [])
addArv j (x:xs) (y:ys) = (s `mod` 10): (addArv (s `div` 10) xs ys)
  where s=x+y+j

-- Arvude listi liitmine
addArvList :: [Arv]->Arv
addArvList ar = foldr (addArv 0) (repeat 0) ar

-- Arvu (listi) korrutamine täisarvuga (int) multint 0 2 (arv "25")=>[0,5]
-- Esimene argument - jääk
-- Teine argument - täisarv (int)
-- Eeldab, et väikseim(positsiooniliselt) number tuleb kõige ees
multint :: Int->Int->Arv->Arv
multint j x [] = if (j==0) then [] else [j]
multint j x (y:ys) = (m `mod` 10) : multint (m `div` 10) x ys
  where m=x*y+j

-- Korrutamine etteantud täpsuseni (osa ülesandest)
multPrecise :: Int->Arv->Arv->Arv
multPrecise n x y = take n (mult x y)

-- Astendamine etteantud täpsuseni (osa ülesandest)
expPrecise :: Int->Int->Arv->Arv
expPrecise n 0 _ = [1]
expPrecise n e x = multPrecise n x (expPrecise n (e-1) x)

-- Täisarvu teisendamine Arvuks
int2arv :: Integer->[Integer]
int2arv 0 = []
int2arv n = (n `mod` 10): int2arv (n `div` 10)

-- Arvu teisendamine täisarvuks
arv2int :: [Integer]->Integer
arv2int [] = 0
arv2int (x:xs) = (fromIntegral x) + 10 * (arv2int xs)

-- Ülesande enda lahendus, avaldise 1^1 + 2^2 + 3^3 + ... + 1000^1000 10 viimase numbri leidmine
euler48 :: Integer->Integer
euler48 1 = 1
euler48 n = (+) (arv2int (take 11 (int2arv (n^n)))) (euler48 (n-1))