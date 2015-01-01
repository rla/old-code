<?php

/**
*Graafikute joonistamine. Astroid
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

define(a, 1);

//Parameetrilised funktsioonid astroidi joonistamiseks.

function x($t) {

	return a*pow(cos($t), 3);

}

function y($t) {

	return a*pow(sin($t), 3);

}

$graph=new Graph(500, 500, 1.5, 1.5, "astroid.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawParametricFunction(x, y, 0, 2*PI);

$graph->Close();

?>