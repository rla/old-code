<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Html";
$sisu_array["sisu"]="&nbsp; &nbsp;Html põhitõed, näited ja mõned java skriptid.";
$sisu_array["pic"]="";

$fp=fopen("et_html.dat", "r");
$dynamic=""; //muutuja kus hoiame muutuvat sisu
while (!feof($fp)) {
	$dl=fgets($fp);
	$dl_array=explode('*', $dl);
	$img="<img src=\"". $dl_array[0] ."\" hspace=\"10\">";
	$link="<a href=\"". $dl_array[1] ."\" class=\"text\" target=\"_blank\">". $dl_array[2] ."</a>&nbsp; &nbsp;";
	$dynamic=$dynamic .$img .$link ."<br>";
}
fclose($fp);
$sisu_array["dynamic"]=$dynamic;
?>