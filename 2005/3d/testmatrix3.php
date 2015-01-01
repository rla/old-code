<?php

/**
*PHP 3D vahendid. Maatriksi test. Korrutamine.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("matrix.php");

$m1=new Matrix(1, 3);
$m1->setElement(0, 0, 1.0);
$m1->setElement(0, 1, -2.0);
$m1->setElement(0, 2, 3.0);

$m1->output();

$m2=new Matrix(3, 3);
$m2->setElement(0, 0, 1.0);
$m2->setElement(0, 1, -1.0);
$m2->setElement(0, 2, 1.0);

$m2->setElement(1, 0, 2.0);
$m2->setElement(1, 1, 1.0);
$m2->setElement(1, 2, -2.0);

$m2->setElement(2, 0, -1.0);
$m2->setElement(2, 1, 3.0);
$m2->setElement(2, 2, -3.0);

$m2->output();

$m=matrixMult($m1, $m2);

echo "Korrutis:\r\n";
$m->output();

?>