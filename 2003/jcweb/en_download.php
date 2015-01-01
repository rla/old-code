<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]="en";
$sisu_array["local_title"]="Download";
$sisu_array["sisu"]="Most of the progs that you can download from here are freeware.";
$sisu_array["pic"]="<img src=\"graphics/floppy.gif\" hspace=\"10\">";

$fp=fopen("en_download.dat", "r");
$dynamic=""; //muutuja kus hoiame muutuvat sisu
while (!feof($fp)) {
	$dl=fgets($fp);
	$dl_array=explode('*', $dl);
	$img="<img src=\"". $dl_array[0] ."\" hspace=\"10\">";
	$dl_link="<a href=\"". $dl_array[1] ."\" class=\"text\">". $dl_array[2] ."</a>&nbsp; &nbsp;";
	$hp_link="<a href=\"". $dl_array[3] ."\" class=\"text\">Homepage</a>";
	$dynamic=$dynamic .$img .$dl_link .$hp_link ."<br>";
}
fclose($fp);
$sisu_array["dynamic"]=$dynamic;

?>