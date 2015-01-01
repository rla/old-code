<?php

/**
*Graafikute joonistamine. Bernoull'i lemniskaat
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

define(a, 1);

//Funktsioon Bernoull'i lemniskaadi joonistamiseks.

function r($phi) {

	if (cos(2*$phi)>=0) return sqrt(pow(a, 2)*cos(2*$phi));
	return sqrt(-pow(a, 2)*cos(2*$phi));

}

$graph=new Graph(500, 500, 1, 1, "bernoull_lemn.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawPolarFunction(r, 0, 2*PI);

$graph->Close();

?>