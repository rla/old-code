<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Lingid";
$sisu_array["sisu"]="&nbsp; &nbsp;Minu lingikogu";
$sisu_array["pic"]="<img src=\"graphics/lingid.jpg\" hspace=\"10\">";

switch($subsubid) {
	case 1:
	$fnimi=$keel ."_lingid.dat";
	break;
	case 2:
	$fnimi=$keel ."_lingid_2.dat";
	$sisu_array["local_title"]="Lingid - weeb";
	$sisu_array["sisu"]="&nbsp; &nbsp;Lingid weebi tegemise kohta jms.";
	break;
	case 3:
	$fnimi=$keel ."_lingid_3.dat";
	$sisu_array["local_title"]="Lingid - progemine";
	$sisu_array["sisu"]="&nbsp; &nbsp;Programmeerimise lingid.";
	break;
	case 4:
	$fnimi=$keel ."_lingid_4.dat";
	$sisu_array["local_title"]="Lingid - autod";
	$sisu_array["sisu"]="&nbsp; &nbsp;Autod";
	break;
	case 5:
	$fnimi=$keel ."_lingid_5.dat";
	$sisu_array["local_title"]="Lingid - mängud";
	$sisu_array["sisu"]="&nbsp; &nbsp;Mängude leheküljed.";
	break;
	case 6:
	$fnimi=$keel ."_lingid_6.dat";
	$sisu_array["local_title"]="Lingid - muusika";
	$sisu_array["sisu"]="&nbsp; &nbsp;Muusika lingid.";
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