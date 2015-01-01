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
Mysql andmebaasi olemasolu veakontroll.
Vajalikud vaikimisi muutujad (asuvad tabelis (site_name)_content):
	cache_timeout - sekundid lehe uuendamiseni võrreldes
    vahekaustas oleva lehe loomise ajaga.
    def_lang - vaikimisi keel.
    show_site - kui väärtus 1, siis näidatakse saiti.
Lisatud konfiguratsioonifail conf/site.conf
--end

Versioon 0.06
--end

Versioon 0.07
Html parser käivitatud.
--end

Versioon 0.09
Html parser eemaldatud.
Lehe määrajaks URI muutuja page.
--end

Raivo Laanemets 2004
*/

include('func/system.php');
$id=$_GET['id'];     if ($id=='')   { $_GET['id']='index'; $id='index'; }
if($_GET['lang']!=''): $LANG=$_GET['lang'];
else:
	$LANG='ee';
    $_GET['lang']='ee';
endif;

//struktuuri muutuja
$struct=$_GET['struct'];
if ($struct==''): $STRUCTURE='struct';
else: $STRUCTURE=$struct;
endif;

$cache_file_name='cache/' .GetUrlFile() .'.php';
$menu=array();


//kontrollitakse, kas soovitav lehekülg
//asub vahekaustas, või tuleb ta tekitada.
//Fail tekitatakse uuesti ka siis kui ta on vananenud
if ($cache_only) {
	include($cache_file_name);
} else {

	$html=''; //lehe sisu, vajalik hilisemaks töötluseks.

	//NB!! Siia paigutame lehekülje
    //vahekausta loomiseks vajalikud funktsioonid
    //ja inkluuded
    include_once('func/main.php');
    include_once('func/print_msg.php');
    include_once('func/errors.php');
    //include_once('func/parsehtml.php');
    include_once('func/html_callback.php');

    //mysql andmebaasist info võtt
    include('conf/system_mysql.php');

    $objects_db=@mysql_connect($objects_host, $objects_user, $objects_pass, true)
    	or die('Ei õnnestunud ühendada mysql baasiga.');
    if(!mysql_select_db($objects_base)) print mysql_error($objects_db);

    $DEFAULT_LANG=ReadSetting('def_lang');

    $title=DEFAULT_TITLE;
    $LAST_ERROR='';

	ob_start(); //väljundi bufferdamine
	//loetakse struktuur.
    //alates 0.04 on võimalik struktuuri muuta url ribalt.
	Object($STRUCTURE, $LANG);
	//kui lehte pole vahekaustas, siis tuleb ta
	//tekitada ning salvestada sinna ja ka väljastada.
    CacheOutput();
    ob_end_clean();

	//Algab html lehe töötlus
    //muutujat $html pole enam lehe näitamiseks vaja.
    //ParseHTML($html, true);

    mysql_close($objects_db);
    include($cache_file_name);
}

?>