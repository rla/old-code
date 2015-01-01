<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]="et";
$sisu_array["local_title"]="Tõmbamine";
$sisu_array["sisu"]="Programmid on tasuta või jaosvaralised. Viimati uuendatud 20.08.03";
$sisu_array["pic"]="<img src=\"graphics/floppy.gif\" hspace=\"10\">";

$fp=fopen("et_download.dat", "r");
$dynamic=""; //muutuja kus hoiame muutuvat sisu
while (!feof($fp)) {
	$dl=fgets($fp);
	$dl_array=explode('*', $dl);
	$img="<img src=\"". $dl_array[0] ."\" hspace=\"10\">";
	$dl_link="<a href=\"". $dl_array[1] ."\" class=\"text\">". $dl_array[2] ."</a>&nbsp; &nbsp;";
	$hp_link="<a href=\"". $dl_array[3] ."\" class=\"text\">Koduleht</a>";
	$dynamic=$dynamic .$img .$dl_link .$hp_link ."<br>";
}
fclose($fp);
$sisu_array["dynamic"]=$dynamic;

?>