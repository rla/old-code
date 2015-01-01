<?php

/**
*Lissajous kujundite joonistamine.
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*
*Kasutamine(näide): $ php lissajous.php 1 2
*Tulem: pildifail lissajous_1_2.png
*/

include("graph.php");
include("math.php");

$a=(int)$argv[1];
$b=(int)$argv[2];

if (!$a) print "Sisesta fx suhteline sagedus!\r\n";
if (!$b) { print "Sisesta fy suhteline sagedus!\r\n"; return; }

function x($t) { global $a; return cos($a*$t); }
function y($t) { global $b; return sin($b*$t); }

$graph=new Graph(400, 400, 1.5, 1.5, "lissajous_" .$a ."_" .$b .".png");

$graph->DrawParametricFunction(x, y, 0, 2*PI);

$graph->Close();

?>