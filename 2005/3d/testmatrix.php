<?php

/**
*PHP 3D vahendid. Maatriksi test.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("matrix.php");

$mat=new Matrix(4, 4);

$mat->setElement(0, 0, 5.0);
$mat->setElement(0, 1, 3.0);
$mat->setElement(0, 2, 7.0);
$mat->setElement(0, 3, 3.0);

$mat->setElement(1, 0, 2.0);
$mat->setElement(1, 1, 4.0);
$mat->setElement(1, 2, 9.0);
$mat->setElement(1, 3, 5.0);

$mat->setElement(2, 0, 3.0);
$mat->setElement(2, 1, 6.0);
$mat->setElement(2, 2, 4.0);
$mat->setElement(2, 3, 7.0);

$mat->setElement(3, 0, 4.0);
$mat->setElement(3, 1, 5.0);
$mat->setElement(3, 2, 7.0);
$mat->setElement(3, 3, 1.0);

$mat->output();

echo "Determinant: " .$mat->determinant() ."\r\n";

?>