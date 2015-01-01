<?php

/**
*Matemaatilised funktsioonid ja konstandid.
*
*@author Raivo Laanemets
*@version 1.02
*/

/**Pii*/
define("PI", 3.141592654);

/**e*/
define("e", 2.718281828);

/**1 kraad radiaanides*/
define("DEG", PI/180.0);

/**
*Ruututõstmine.
*@param float $x Ruutu tõstetav arvuline väärtus.
*@returns float Ruutu tõstetud ette antud väärtus.
*/
function sqr($x) {

	return $x*$x;

}

/**
*Faktoriaali leidmine.
*@param $n täisarv, millest faktoriaal arvutatakse.
*/
function fact($n) {

	if ($n==0) return 1;
	return $n*fact($n-1);

}

/**
*Kahe elemendi vahetus.
*/
function swap(&$e1, &$e2) {

	$tmp=$e1;
	$e1=$e2;
	$e2=$tmp;

}


?>