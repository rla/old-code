<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Projektid";
$sisu_array["sisu"]="&nbsp; &nbsp;Valmis tehtud asjad.";
$sisu_array["pic"]="<img src=\"graphics/projektid.jpg\" hspace=\"10\">";

switch($subsubid) {
	case 1:
	$fnimi=$keel ."_projektid.dat";
	break;
	case 2:
	$fnimi=$keel ."_projektid_2.dat";
	$sisu_array["local_title"]="Projektid - weeb";
	$sisu_array["sisu"]="&nbsp; &nbsp;Minu poolt tehtud või teha aidatud kodulehed.";
	break;
	case 3:
	$fnimi=$keel ."_projektid_3.dat";
	$sisu_array["local_title"]="Projektid - programmid.";
	$sisu_array["sisu"]="&nbsp; &nbsp;Mõned kasulikud programmid.";
	break;
	case 4:
	$fnimi=$keel ."_projektid_4.dat";
	$sisu_array["local_title"]="Projektid - mitmesugust.";
	$sisu_array["sisu"]="&nbsp; &nbsp;Asjad millega tegelenud olen.";
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