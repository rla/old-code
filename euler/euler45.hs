module Euler45 where
import TriList

triangle :: Int->Int
triangle n = div (n*(n+1)) 2

pentagonal :: Int->Int
pentagonal n = div (n*(3*n-1)) 2

hexagonal :: Int->Int
hexagonal n = n*(2*n-1)

trianglepentagonal a b = (a*(a+1))==(b*(3*b-1))

trlist=[ triangle n | n<-[1..] ]
pentalist=[ pentagonal n | n<-[1..] ]
hexalist=[ hexagonal n | n<-[1..] ]

pent2tr k = negate 1/2 +sqrt(1+12*k**2-4*k)/2
isInteger k = (mod (round (k*10000)) 10000) == 0
hexa2tr k = negate 1/2 +sqrt(1+16*k**2-8*k)/2
pent2hexa k = (2+sqrt(4+4*4*(3*k**2-k)))/8

-- 1073741822