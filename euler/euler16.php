<?php

/*
Problem 16

2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.

What is the sum of the digits of the number 2^1000?

Solution by Raivo Laanemets
28th December 2004
*/

$exp=1000; //exponent
$digits=array(2); //array of digits
$c=1; //count of digits

for ($i=1; $i<$exp; $i++) {

	$c=count($digits);
	$over=0;
	
	for ($j=0; $j<$c; $j++) {
	
		$acc=$digits[$j]*2+$over;
		
		if ($acc>9) {
			$digits[$j]=$acc%10;
			$over=floor($acc/10);
		} else {
			$digits[$j]=$acc;
			$over=0;
		}
	}
	
	if ($over>0 && !isset($digits[$c])) $digits[$c]=$over;
}

echo "2^" .$exp ."=";

$sum=0;
for ($i=count($digits)-1; $i>=0; $i--) { echo $digits[$i]; $sum+=$digits[$i]; }

echo "\nSum of digits: " .$sum ."\n";

echo "\nReady\n";

?> 
