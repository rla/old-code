<?php

/**
*Graafikute joonistamine. Kuuliots
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

define(a, 1);

//Funktsioon kuuli otsa joonistamiseks.

function x($t) {

	

}

$graph=new Graph(500, 500, 1, 1, "kuuliots.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawPolarFunction(r, 0, 2*PI);

$graph->Close();

?>