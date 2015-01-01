<?php

/**
*Graafikute joonistamine. Neljaleheline roos
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

include("graph.php");
include("math.php");

define(a, 1);

//Funktsioon neljalehelise roosi joonistamiseks.

function r($phi) {

	return a*abs(sin(2*$phi));

}

$graph=new Graph(500, 500, 1, 1, "neljal_roos.png");
$graph->DrawAxis();

$graph->SetColor(255, 0, 0);
$graph->DrawPolarFunction(r, 0, 2*PI);

$graph->Close();

?>