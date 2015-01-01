<?php

/**
*PHP 3D vahendid. 3D objektide pööramiseks mõeldud maatriksid.
*Sisaldab pööramiseks arvutatud maatriksite saamise funktsioone.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("matrix.php");
require_once("math.php");

/**
*Ümber x-telje pööramiseks mõeldud maatriks.
*@param float $x Pöördenurk radiaanides.
*@returns Matrix Pööramiseks vajalik maatriks.
*/
function rotateMatrixX($x) {

	$m=new Matrix(3, 3);
	
	$m->setMatrix(array(
		array(1, 0, 0),
		array(0, cos($x), sin($x)),
		array(0, -sin($x), cos($x))
	));
	
	return $m;

}

/**
*Ümber y-telje pööramiseks mõeldud maatriks.
*@param float $x Pöördenurk radiaanides.
*@returns Matrix Pööramiseks vajalik maatriks.
*/
function rotateMatrixY($y) {

	$m=new Matrix(3, 3);
	
	$m->setMatrix(array(
		array(cos($y), 0, -sin($y)),
		array(0, 1, 0),
		array(sin($y), 0, cos($y))
	));
	
	return $m;

}

/**
*Ümber z-telje pööramiseks mõeldud maatriks.
*@param float $z Pöördenurk radiaanides.
*@returns Matrix Pööramiseks vajalik maatriks.
*/
function rotateMatrixZ($z) {

	$m=new Matrix(3, 3);
	
	$m->setMatrix(array(
		array(cos($z), sin($z), 0),
		array(-sin($z), cos($z), 0),
		array(0, 0, 1)
	));
	
	return $m;

}

/**
*Ümber telgede pööramiseks mõeldud maatriks.
*@param float $x Pöördenurk ümber x-telje radiaanides.
*@param float $y Pöördenurk ümber y-telje radiaanides.
*@param float $z Pöördenurk ümber z-telje radiaanides.
*@returns Matrix Pööramiseks vajalik maatriks.
*/
function rotateMatrixXYZ($x, $y, $z) {

	$m=new Matrix(3, 3);
	
	$m->setMatrix(array(
		array(cos($y)*cos($z), cos($y)*sin($z), -sin($y)),
		array(sin($x)*sin($y)*cos($z)-cos($x)*sin($z), sin($x)*sin($y)*sin($z)+cos($x)*cos($z), sin($x)*cos($y)),
		array(cos($x)*sin($y)*cos($z)+sin($x)*sin($z), cos($x)*sin($y)*sin($z)-sin($x)*cos($z), cos($x)*cos($y))
	));
	
	return $m;

}

/**
*Ümber vektori pööramiseks mõeldud maatriks.
*@param Vector $n Vektor.
*@param float $a Pöördenurk radiaanides.
*@returns Matrix Pööramiseks vajalik maatriks.
*/
function rotateMatrixVector($n, $a) {

	$m=new Matrix(3, 3);
	
	$nx=$n->getX();
	$ny=$n->getY();
	$nz=$n->getZ();
	
	$m->setMatrix(array(
		array(sqr($nx)+(1-sqr($nx))*cos($a), $nx*$ny*(1-cos($a))-$nx*sin($a), $nx*$nz*(1-cos($a))+$ny*sin($a)),
		array($nx*$ny*(1-cos($a))+$nx*sin($a), sqr($ny)+(1-sqr($ny))*cos($a), $ny*$nz*(1-cos($a))-$nx*sin($a)),
		array($nx*$nz*(1-cos($a))-$ny*sin($a), $ny*$nz*(1-cos($a))+$nx*sin($a), sqr($nz)+(1-sqr($nz))*cos($a))
	));
	
	return $m;

}

/**
*Maatriksi $m täitmine nullidega.
*@param Matrix $m Maatriks.
*@returns void.
*/
function resetMatrix($m) {

	for ($i=0; $i<$m->getM(); $i++) for ($j=0; $j<$m->getN(); $j++) $m->setElement($i, $j, 0.0);

}

/**
*Punkti teisendus maatriksiga.
*@param Vector $v Punkt vektori kujul.
*@param Matrix $mat 3x3 teisendusmaatriks.
*@param Vector $o Objekti keskpunkt vektori kujul.
*@returns Vector Antud punkti teisendus antud vektoriga.
*/
function transformVertex($v, $mat, $o) {

	return new Vector(
		$v->getX()*$mat->getElement(0, 0)+$v->getY()*$mat->getElement(1, 0)+$v->getZ()*$mat->getElement(2, 0)+$o->getX(),
		$v->getX()*$mat->getElement(0, 1)+$v->getY()*$mat->getElement(1, 1)+$v->getZ()*$mat->getElement(2, 1)+$o->getY(),
		$v->getX()*$mat->getElement(0, 2)+$v->getY()*$mat->getElement(1, 2)+$v->getZ()*$mat->getElement(2, 2)+$o->getZ()
	);

}

/**
*Punkti kui objekti maatriksi saamine.
*@param $v Punkt vektori kujul.
*@returns Matrix Antud punkti kui objekti maatriks.
*/
function vertexMatrix($v) {

	$m=new Matrix(3, 3);
	$m->setMatrix(array(
		array($v->getX(), 0, 0),
		array(0, $v->getY(), 0),
		array(0, 0, $v->getZ())
	));
	
	return $m;

}

?>