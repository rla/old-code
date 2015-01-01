<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Programmeerimine";
$sisu_array["sisu"]="&nbsp; &nbsp;Materialid programeerimise kohta. Näited ja seletused.";
$sisu_array["pic"]="<img src=\"graphics/progemine.jpg\" hspace=\"10\">";

switch($subsubid) {
	case 1:
	$fnimi=$keel ."_progemine.dat";
	break;
	case 2:
	$fnimi=$keel ."_progemine_2.dat";
	$sisu_array["local_title"]="Programmeerimine - näited";
	$sisu_array["sisu"]="&nbsp; &nbsp;Enamik näidetest on turbo pascal/delphi näited. Kõiki võib vabalt kasutada.";
	break;
	case 3:
	$fnimi=$keel ."_progemine_3.dat";
	$sisu_array["local_title"]="Programmeerimine - tekstid";
	$sisu_array["sisu"]="&nbsp; &nbsp;Tekstid programmeerimise kohta. Enamik pdf failid.";
	break;
}

$fp=fopen($fnimi, "r");
$dynamic=""; //muutuja kus hoiame muutuvat sisu
while (!feof($fp)) {
	$dl=fgets($fp);
	$dl_array=explode('*', $dl);
	$img="&nbsp; &nbsp;";
	if ($subsubid=="1") $img="<img src=\"". $dl_array[0] ."\" hspace=\"10\">";
	$link="<a href=\"". $dl_array[1] ."\" class=\"text\">". $dl_array[2] ."</a>&nbsp; &nbsp;";
	$dynamic=$dynamic .$img .$link ."<br>";
}
fclose($fp);
$sisu_array["dynamic"]=$dynamic;
?>