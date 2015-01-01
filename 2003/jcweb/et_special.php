<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Special";
$sisu_array["sisu"]="&nbsp; &nbsp; Special - edasi pääsemiseks pead sisestama parooli.";
$sisu_array["pic"]="";

$fnimi=$keel ."_special.dat";

if ((isset($pass)) && ($pass=="princo")) {
	$fp=fopen($fnimi, "r");
	$dynamic=""; //muutuja kus hoiame muutuvat sisu
	while (!feof($fp)) {
		$dl=fgets($fp);
		$dl_array=explode('*', $dl);
		$img="<img src=\"". $dl_array[0] ."\" hspace=\"10\">";
		$link="<a href=\"". $dl_array[1] ."\" class=\"text\">". $dl_array[2] ."</a>&nbsp; &nbsp;";
		$dynamic=$dynamic .$img .$link ."<br>";
	}
	fclose($fp);
	if ($subsubid=="1") $sisu_array["sisu"]="&nbsp; &nbsp; Special - tellitavad cd-d.";
} else {
	$dynamic="<form action=\"index.php?mis=special&keel=et\" method=\"post\">";
	$dynamic=$dynamic ."&nbsp; &nbsp; <input type=\"text\" maxlenght=\"100\" name=\"pass\"><br><br>";
	$dynamic=$dynamic ."&nbsp; &nbsp; <input type=\"submit\" value=\"Sisene\">";
	$dynamic=$dynamic ."</form>";
}
$sisu_array["dynamic"]=$dynamic;
?>