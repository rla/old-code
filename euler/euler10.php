<?php

/*
Problem 10

The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

Find the sum of all the primes below one million.

Solution by Raivo Laanemets
27th December 2004
Requires primes database.
*/

mysql_connect("localhost", "root", "xxx") or die(mysql_error());
mysql_select_db("matemaatika");

$res=mysql_query("SELECT SUM(x) FROM primes WHERE x<1000000");
$result=mysql_fetch_row($res);

echo "Ready, the answer was " .$result[0] ."\n";

mysql_close();

?>
