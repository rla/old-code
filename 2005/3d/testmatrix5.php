<?php

/**
*PHP 3D vahendid. Maatriksi test. Pööramise test.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("matrix.php");
require_once("matrix3d.php");
require_once("math.php");
require_once("vector.php");
require_once("graph.php");

define("SCALE", 256);

$tm=new Matrix(3, 3);
$t_om=new Matrix(3, 3);

$g=new Graph(500, 500, 500, 500, "testmatrix5.png");

//Pöördenurgad, 1 kraad.

$xa=DEG;
$ya=DEG;
$za=DEG;

//Keskpunkt

$o=new Vector(0, 0, SCALE);

//Punkt

$p=new Vector(50, 40, 30);

//Punkti kui objekti maatriks.

$om=vertexMatrix($p);
$om->output();

for ($f=0; $f<200; $f++) {

	$t_om=vertexMatrix($o);
	
	$tm=rotateMatrixXYZ($xa, $ya, $za);
	
	$om=matrixMult($om, $tm);
	
	$t_om=matrixMult($t_om, $om);
	
	//Teisendame punkti
	
	$p=transformVertex($p, $t_om, $o);
	
	$x=$p->getX()*SCALE/$p->getZ();
	$y=$p->getY()*SCALE/$p->getZ();
	
	$p->setX($x);
	$p->setY($y);
	
	//Normaliseerime
	
	$p=$p->getUnit();
	
	//Joonistame punkti
	
	$g->drawDot($x, $y);

}

$g->Close();

?>