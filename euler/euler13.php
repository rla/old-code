<?php

/*
Problem 13

Work out the first 10 digits of the sum of the following one-hundred 50-digit numbers.

Solution by Raivo Laanemets
28th December 2004
*/

//Reading numbers from file euler13.inp

$fp=fopen("euler13.inp", "r");

$row=array();
$numbers=array();
$rows=0;
while(!feof($fp)) {
	$r=fgets($fp);
	$rows++;
	for ($i=0; $i<50; $i++) $row[$i]=(int)$r{$i};
	$numbers[]=$row;
}

fclose($fp);

//Calculating column sums.

$sums=array();
for ($i=49; $i>=0; $i--) {
	$sum=0;
	for ($j=0; $j<$rows; $j++) {
		$sum+=$numbers[$j][$i];
	}
	
	$sums[$i]=$sum;
}

//Calculating digits, 2.-12.

$over=0;
$digits=array();
for ($i=49; $i>=0; $i--) {
	$sum=$sums[$i]+$over;
	$over=floor($sum/10);
	$digits[$i]=$sum%10;
}

for ($i=0; $i<10; $i++) echo $digits[$i];

//First 1.-2. digits

echo "\nhigh: " .$over;

echo "\nReady\n";

?> 
