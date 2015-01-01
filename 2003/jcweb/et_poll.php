<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["local_title"]="Poll";
$sisu_array["sisu"]="&nbsp; &nbsp;Polli tulemused.";
$sisu_array["pic"]="<img src=\"graphics/poll.jpg\" hspace=\"10\">";

$fnimi=$keel ."_poll.dat";

if (isset($rb)) {
	$fp=fopen($fnimi, 'r+');
	$rb_=fread($fp, filesize($fnimi));
	$rb_array=explode(',', $rb_);
	$rb_array[$rb-1]++;
	$rb_=implode(',', $rb_array);
	fseek($fp, 0, SEEK_SET);
	fwrite($fp, $rb_);
	fclose($fp);
	}	  
$fp=fopen($fnimi, "r");
$rb_=fread($fp, filesize($fnimi));
$rb_array=explode(',', $rb_);

fclose($fp);

$dynamic="<table border=\"0\">"; //muutuja kus hoiame muutuvat sisu

$tr_a="<tr><td class=\"text\">&nbsp; &nbsp;";
$tr_v_1="</td><td class=\"text\">";
$tr_v="</td><td class=\"text\"><img src=\"graphics/riba.gif\" height=\"5\" width=\"";
$tr_l="\"></td></tr>";

$v1=$rb_array[0];
$v2=$rb_array[1];
$v3=$rb_array[2];
$v4=$rb_array[3];
$v5=$rb_array[4];
		  
$total=$v1+$v2+$v3+$v4+$v5;

$v1p=round(($v1*100)/$total,0); 
$v2p=round(($v2*100)/$total,0); 
$v3p=round(($v3*100)/$total,0); 
$v4p=round(($v4*100)/$total,0); 
$v5p=round(($v5*100)/$total,0);

$dynamic=$dynamic .$tr_a ."Väga hea" .$tr_v_1 .$v1p .'%' .$tr_v .$v1p .$tr_l;
$dynamic=$dynamic .$tr_a ."Hea" .$tr_v_1 .$v2p .'%' .$tr_v .$v2p .$tr_l;
$dynamic=$dynamic .$tr_a ."Rahuldav" .$tr_v_1 .$v3p .'%' .$tr_v .$v3p .$tr_l;
$dynamic=$dynamic .$tr_a ."Halb" .$tr_v_1 .$v4p .'%' .$tr_v .$v4p .$tr_l;
$dynamic=$dynamic .$tr_a ."Väga halb" .$tr_v_1 .$v5p .'%' .$tr_v .$v5p .$tr_l;

$dynamic=$dynamic ."</table>";

$sisu_array["dynamic"]=$dynamic;
?>