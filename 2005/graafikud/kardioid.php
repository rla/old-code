<?php

/**
*Graafikute joonistamine. Kardioid (süda)
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

define(a, 1);

//Funktsioon kardioidi joonistamiseks.

function r($phi) {

	return a*(1+cos($phi));

}

$graph=new Graph(500, 500, 3, 4, "kardioid.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawPolarFunction(r, 0, 2*PI);

$graph->Close();

?>