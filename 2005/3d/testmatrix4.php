<?php

/**
*PHP 3D vahendid. Maatriksi test. Pööramiseks vajalikud maatriksid.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("matrix.php");
require_once("matrix3d.php");
require_once("math.php");
require_once("vector.php");

$m=rotateMatrixX(PI);

$m->output();

$m=rotateMatrixY(PI);

$m->output();

$m=rotateMatrixZ(PI);

$m->output();

$v=new Vector(1, 0, 0);

$m=rotateMatrixVector($v, 0);

$m->output();

resetMatrix($m);

$m->output();

?>