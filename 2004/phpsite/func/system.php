<?php

/*
system.php
Indeksi kõige põhilisemad funktsioonid ja muutujad.
*/

define('nl', "\n"); //uus rida
define('def_lang', 'ee');

//Get muutujatest failinime tekitamine
function GetUrlFile() {
	$path='';
	foreach($_GET as $value) $path.=$value;
    return md5($path);
}

?>