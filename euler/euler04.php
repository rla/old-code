<?php

/*

Problem 4

A palindromic number reads the same both ways.
The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 x 99.

Find the largest palindrome made from the product of two 3-digit numbers.

Solution by Raivo Laanemets
27th December 2004
*/

function ispalindrome($x) {
	$s=(string)$x;
	for ($i=0; $i<(strlen($s)/2); $i++) if ($s{$i}!=$s{strlen($s)-$i-1}) return false;
	return true;
}

$largest=0;
for ($i=100; $i<1000; $i++)
	for ($j=100; $j<1000; $j++) {
		$x=$i*$j;
		if (ispalindrome($x) && $x>$largest) $largest=$x;
	}

echo "Ready, the answer is " .$largest ."\n";
	
?>