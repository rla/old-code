<?php

/*
index.php

versioon 0.04
Lisatud get muutuja struct, mis võimaldab
lehekülje struktuuri muuta näiteks parema
printimise eesmärgil.
--end

versioon 0.05
cache failinimed md5() kaudu.
Kaotatud vajadus faili conf/main.php järele.
--end

Raivo Laanemets 2004
*/

define('nl', "\n"); //uus rida

function getmicrotime() { // declares the function getmicrotime.
	list($usec, $sec) = explode(" ",microtime()); // please refer to the individual explanation.
	return ((float)$usec + (float)$sec); // please refer to the individual explanation.
}

$time_start = getmicrotime();

//get muutujatest failinime tekitamine
function GetUrlFile() {
	$path='p';
	foreach($_GET as $value) $path.='_' .$value;
    return md5($path);
}

//kontrollib, kas vahekaustas olev fail on vananenud
function CacheExpired($filename) {
	if ((filemtime($filename)+CACHE_EXPIRES)<time()) return true;
    else return true;
}

$id=$_GET['id'];     if ($id=='')   { $_GET['id']='index'; $id='index'; }
$lang=$_GET['lang']; if ($lang=='') { $_GET['lang']='ee'; $lang='ee'; }

//struktuuri muutuja
$struct=$_GET['struct'];
if ($struct==''): $STRUCTURE='struct';
else: $STRUCTURE=$struct;
endif;

$cache_file_name='cache/' .GetUrlFile() .'.html';
$menu=array();
//kontrollitakse, kas soovitav lehekülg
//asub vahekaustas, või tuleb ta tekitada.
//Fail tekitatakse uuesti ka siis kui ta on vananenud
if (file_exists($cache_file_name) && !CacheExpired($cache_file_name)) {
	include($cache_file_name);
} else {
	//NB!! Siia paigutame lehekülje
    //vahekausta loomiseks vajalikud funktsioonid
    //ja inkluuded
    include_once('func/main.php');
    include_once('func/print_msg.php');
    include_once('func/errors.php');

    //mysql andmebaasist info võtt
    include('conf/system_mysql.php');

    $objects_db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($objecst_db)) print mysql_error($objects_db);
    if(!mysql_select_db($objects_base)) print mysql_error($objects_db);

    /////////NB!!!!!!!
    $DEFAULT_LANG=ReadSetting('def_lang');
    $lang=$DEFAULT_LANG;
    $_GET['lang']=$lang;
    /////////////--end

    $title=DEFAULT_TITLE;
    $LAST_ERROR='';

	ob_start(); //väljundi bufferdamine
	//loetakse struktuur.
    //alates 0.04 on võimalik struktuuri muuta url ribalt.
	Object($STRUCTURE, 'ee');
	//kui lehte pole vahekaustas, siis tuleb ta
	//tekitada ning salvestada sinna ja ka väljastada.
    CacheOutput();
    ob_end_clean();

    mysql_close($objects_db);
    include($cache_file_name);
}

?>