<?php

/*
Problem 19

You are given the following information, but you may prefer to do some research for yourself.

1 Jan 1900 was a Monday.
Thirty days has September,
 April, June and November.
 All the rest have thirty-one,
 Saving February alone,
 Which has twenty-eight, rain or shine.
 And on leap years, twenty-nine.
A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.

How many Sundays fell on the FIRST of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?

Solution by Raivo Laanemets
28th December 2004
*/

$sum=0; //Sum of days
$eps=0.0001;
for ($i=1901; $i<=2000; $i++) {
	if (($i%4<$eps && $i%100>$eps) || $i%400<$eps) {
		$sum+=366;
		echo $i ."\n";
	} else {
		$sum+=365;
	}
}

echo "Answer: " .floor($sum/7) ."\nReady\n";

?> 
