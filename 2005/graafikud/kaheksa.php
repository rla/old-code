<?php

/**
*Graafikute joonistamine. Ringjoon
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

define(a, 1);

//Parameetrilised funktsioonid kaheksa joonistamiseks.

function x($t) {

	return a*sin($t);

}

function y($t) {

	return a*sin($t)*cos($t);

}

$graph=new Graph(500, 500, 1, 1, "kaheksa.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawParametricFunction(x, y, 0, 8*PI);

$graph->Close();

?>