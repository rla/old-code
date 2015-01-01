<?php

/*
Funktsioon formaaditud teadete
väljastamiseks.

$vars on massiiv, mis sisaldab
vajalike muutujate väärtusi.
$temp on templeit, mida
kasutatakse. Funktsioon sobib
pealkirjade jms. väljastamiseks.

Raivo Laanemets 2004
*/
function PrintMsg(&$vars, $temp) {
	foreach($vars as $key => $value) str_replace('{%' .$key .'%}', $value, $temp);
    print $temp;
}

?>