<?php

/**
*Graafikute joonistamine. Ringjoon
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

//Ringi raadius
define(R, 1);

//Parameetrilised funktsioonid ringjoone joonistamiseks.

function x($t) {

	return R*cos($t);

}

function y($t) {

	return R*sin($t);

}

$graph=new Graph(500, 500, 1.5, 1.5, "ringjoon.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawParametricFunction(x, y, 0, 2*PI);

$graph->Close();

?>