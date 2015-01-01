<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Max - Trivia bot";
$sisu_array["sisu"]="&nbsp; &nbsp;Tõmba siit.";
$sisu_array["pic"]="";

$fnimi=$keel ."_max.inc";

$dynamic=join("",file($fnimi));

$sisu_array["dynamic"]=$dynamic;
?>