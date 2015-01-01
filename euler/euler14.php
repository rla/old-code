<?php

/*
Problem 14

The following iterative sequence is defined for the set of natural numbers:

n * n/2
(n is even)

n * 3n + 1
(n is odd)

Using the rule above and starting with 13, we generate the following sequence:
 
13 * 40 * 20 * 10 * 5 * 16 * 8 * 4 * 2 * 1

It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.

Which starting number, under one million, produces the longest chain?

NOTE: Once the chain starts the terms are allowed to go above one million.

Solution by Raivo Laanemets
28th December 2004
*/

$longest=0;
$longest_i=0;
$eps=0.000001;
for ($i=0; $i<1000000; $i++) {
	$n=$i;
	$c=0;
	while ($n>1) {
		if ($n%2<$eps) $n=floor($n/2);
		else $n=3*$n+1;
		$c++;
	}
	if ($c>$longest) {
		$longest=$c;
		$longest_i=$i;
		echo $longest_i ."\n"; 
	}
}

echo "The answer: " .$longest_i ."\nReady\n";

?> 
