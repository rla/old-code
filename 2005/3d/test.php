<?php

/**
*PHP 3D vahendid. Algkatsed 3D-ga.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("vector.php");
require_once("graph.php");

define("SCALE", 256);

$g=new Graph(500, 500, 320, 200, "test.png");

$x=1;
$y=1;
$z=256;
$gx=$x*256/$z+160;
$gy=$y*256/$z+100;

while ($z>-256) {

	$gx=$x*256/$z;
	$gy=$y*256/$z;
	
	$g->drawDot($gx, $gy);
	 
	$z--;
	
	if ($z==0) $z=-1;
	
	echo $gx ."\r\n";
	
}

$g->Close();


?>