<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Mängud";
$sisu_array["sisu"]="&nbsp; &nbsp;Mängude nimekiri.";
$sisu_array["pic"]="";

$fp=fopen("mang.dat", "r");
$dynamic="<table border=\"0\" cellpadding=\"4\">"; //muutuja kus hoiame muutuvat sisu
$dynamic=$dynamic ."<tr><td class=\"text\"><b>Nimi</b></td><td class=\"text\"><b>Suurus</b></td></tr>";
while (!feof($fp)) {
	$dl=fgets($fp);
	$dl_array=explode('*', $dl);
	$tr_a="<tr>";
	$td_a="<td class=\"text\">";	
	$td_v="</td>" .$td_a;
	$dynamic=$dynamic .$tr_a .$td_a .$dl_array[0] .$td_v .$dl_array[1]. "</td></tr>";
}
fclose($fp);
$dynamic=$dynamic ."</table>";
$sisu_array["dynamic"]=$dynamic;
?>