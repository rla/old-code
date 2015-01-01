<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Doom";
$sisu_array["sisu"]="&nbsp; &nbsp;Doom online.";
$sisu_array["pic"]="<img src=\"graphics/doom.jpg\" hspace=\"10\">";

$fnimi=$keel ."_doom.inc";

$dynamic=join("",file($fnimi));

$sisu_array["dynamic"]=$dynamic;
?>