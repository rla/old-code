<?php

/**
*Float type microtime function.
*Taken from http://www.php.net/microtime
*
*Raivo Laanemets
*/

function microtime_float() {
	list($usec, $sec)=explode(" ", microtime());
	return ((float)$usec + (float)$sec);
}

?>