<?php

/*
Problem 24

A permutaion is an ordered arrangement of objects. For example, 3124 is one possible permutation of the digits 1, 2, 3 and 4. If all of the permutations are listed numerically or alphabetically, we call it lexicographic order. The lexicographic permutations of 0, 1 and 2 are:

012   021   102   120   201   210

What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?

Solution by Raivo Laanemets
1st January 2005
*/

$numbers=array(0, 1, 2);
$place=count($numbers)-2;

for ($i=0; $i<6; $i++) {
	$a=$numbers[$place];
	$b=$numbers[$place+1];
	
	$numbers[$place]=$b;
	$numbers[$place+1]=$a; //swap
	
	$place=$place-1;
	
	if ($place==-1) $place=count($numbers)-2;
	
	print_r($numbers);
}

echo "\nReady\n"

?>