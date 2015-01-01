<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Rqmail";
$sisu_array["sisu"]="&nbsp; &nbsp;Avatud lähtekoodiga mailiprogramm.";
$sisu_array["pic"]="";

$fnimi=$keel ."_rqmail.inc";

$dynamic=join("",file($fnimi));

$sisu_array["dynamic"]=$dynamic;
?>