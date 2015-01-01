<?php

/**
*Graafikute joonistamine. Kolmeleheline roos
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

define(a, 1);

//Funktsioon kolmelehelise roosi joonistamiseks.

function r($phi) {

	return a*sin(3*$phi);

}

$graph=new Graph(500, 500, 1, 1, "kolml_roos.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawPolarFunction(r, 0, 2*PI);

$graph->Close();

?>