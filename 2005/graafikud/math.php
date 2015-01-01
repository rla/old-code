<?php

/**
*Matemaatilised funktsioonid ja konstandid.
*
*@author Raivo Laanemets
*/

/**Pii*/
define(PI, 3.141592654);

/**e*/
define(e, 2.718281828);

/**
*Faktoriaali leidmine.
*@param $n täisarv, millest faktoriaal arvutatakse.
*/
function fact($n) {

	if ($n==0) return 1;
	return $n*fact($n-1);

}


?>