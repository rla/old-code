<?php

/**
*PHP 3D vahendid. Kolmnurga joonistaja.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("graph.php");
require_once("math.php");

$g=new Graph(500, 500, 4.0, 4.0, "triangle.png");

//X-koordinaadid

$x=array(0.0, 1.0, 2.0);

//Y-koordinaadid

$y=array(0.0, 1.0, 2.0);

//Sorteerime punktid y-koordinaadi järgi

if ($y[1]<$y[0]) swap($y[0], $y[1]);
if ($y[2]<$y[1]) swap($y[1], $y[2]);
if ($y[2]<$y[0]) swap($y[0], $y[2]);

var_dump($y);

$delta_x[0]=$x[1]-$x[0];
$delta_y[0]=$y[1]-$y[0];
$delta_x[1]=$x[2]-$x[1];
$delta_y[1]=$y[2]-$y[1];
$delta_x[2]=$x[0]-$x[2];
$delta_y[2]=$y[0]-$y[2];

for ($a=0; $a<3; $a++) {

	if ($delta_y[$a]=!0) d[$a]=delta_x[$a]/delta_y[$a];
	else $d[$a]=0;

}

$g->Close();

?>