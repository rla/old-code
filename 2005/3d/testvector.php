<?php

/**
*Klassi Vector testimine.
*
*@author Raivo Laanemets
*/

require_once("vector.php");

$v1=new Vector(1, 1, 1);
$v2=new Vector(1, 2, 3);

echo $v1;
echo "\r\n";

echo $v2;
echo "\r\n";

echo "dot product: " .dotProduct($v1, $v2) ."\r\n";

echo "projection: " .projection($v1, $v2) ."\r\n";

echo angle($v1, $v2) ." rad\r\n";

?>