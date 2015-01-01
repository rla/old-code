Problem 28


Starting with the number 1 and moving to the right in a
clockwise direction a 5 by 5 spiral is formed as follows:


21 22 23 24 25
20 7  8  9  10
19 6  1  2  11
18 5  4  3  12
17 16 15 14 13


It can be verified that the sum of both diagonals is 101.
What is the sum of both diagonals in a 1001 by 1001
spiral formed in the same way?


Lahendus: Raivo Laanemets rl@starline.ee

1) Alustades keskelt 1-st paremale üles on maatriksi diagonaalil ruutmaatriksi
  külje ruut. n^2

2) Keskelt vasakule üles on maatriksi diagonaalil n^2-n+1, kus on vastava
  ruutmaatriksi mõõde.

3) Keskelt alla vasakule on maatriksi diagonaalil n^2-2*n+2.

4) Keskelt alla paremale on diagonaalil n^2-3*n+3

Summeerimine valemid: S(n)=n^2 + n^2-n+1+ n^2-2*n+2 + n^2-3*n+3=4*n^2 - 6*n +6.

Arvutame Sum(n=1..1001) S(n) sammuga 2.

n=1 korral valem ei kehti, saadakse 4, kuigi peab olema 1.
Võtame seda erindina.

<?php

$sum=1;
for ($n=3; $n<=1001; $n+=2) $sum+=4*$n*$n-6*$n+6;

print "Lõpptulemus: " .$sum ."\n";

?>