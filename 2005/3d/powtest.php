<?php

/**
*Test $x*$x versus pow($x, 2).
*/

function microtime_float() {

	list($usec, $sec) = explode(" ", microtime());
	return ((float)$usec + (float)$sec);
	
}

require("math.php");

$x=67776.6;

$start=microtime_float();

for ($i=0; $i<100000; $i++) {

	$y=$x*$x;

}

echo "Time taken: " .(microtime_float()-$start) ."\r\n";

$start=microtime_float();

for ($i=0; $i<100000; $i++) {

	$y=pow($x, 2);

}

echo "Time taken: " .(microtime_float()-$start) ."\r\n";

$start=microtime_float();

for ($i=0; $i<100000; $i++) {

	$y=sqr($x);

}

echo "Time taken: " .(microtime_float()-$start) ."\r\n";

?>