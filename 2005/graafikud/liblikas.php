<?php

/**
*Graafikute joonistamine. Ringjoon
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

//Parameetrilised funktsioonid liblika joonistamiseks.

function x($t) {

	return sin($t)*(pow(e, cos($t))-2*cos(4*$t)+pow(sin($t/12.0), 5));

}

function y($t) {

	return cos($t)*(pow(e, cos($t))-2*cos(4*$t)+pow(sin($t/12.0), 5));

}

$graph=new Graph(500, 500, 4, 4, "liblikas.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawParametricFunction(x, y, 0, 8*PI);

$graph->Close();

?>