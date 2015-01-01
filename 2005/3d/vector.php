<?php

/**
*PHP 3D vahendid. Vektor ja tehted vektoritega.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("math.php");
require_once("matrix.php");

/**
*Kolme koordinaadiga vektor.
*/
class Vector {

	/**@access private*/
	private $x=0;
	
	/**@access private*/
	private $y=0;
	
	/**@access private*/
	private $z=0;

	/**
	*Konstruktor.
	*@param float $x esimese koordinaadi väärtus.
	*@param float $y teise koordinaadi väärtus.
	*@param float $z kolmanda koordinaadi väärtus.
	*/
	public function __construct($x, $y, $z) {
	
		$this->x=$x;
		$this->y=$y;
		$this->z=$z;
	
	}
	
	/**
	*Vektori pikkuse saamine.
	*@returns float Antud vektori pikkus.
	*/
	public function getLength() {
	
		return sqrt(sqr($this->x)+sqr($this->y)+sqr($this->z));
	
	}
	
	/**
	*Antud vektoriga paralleelse ühikvektori saamine.
	*@returns Vector Ühikvektor.
	*/
	public function getUnit() {
	
		$len=$this->getLength();
		return new Vector($this->x/$len, $this->y/$len, $this->z/$len);
	
	}
	
	/**
	*Tagastab vektori sõnena.
	*@returns string Antud vektor sõnena.
	*/
	public function __toString() {
	
		return "(" .$this->x ."," .$this->y ."," .$this->z .")";
	
	}
	
	/**
	*Vektori esimese koordinaadi saamine.
	*@returns float Vektori esimene koordinaat.
	*/
	public function getX() {
	
		return $this->x;
	
	}
	
	/**
	*Vektori teise koordinaadi saamine.
	*@returns float Vektori teine koordinaat.
	*/
	public function getY() {
	
		return $this->y;
	
	}
	
	/**
	*Vektori kolmanda koordinaadi saamine.
	*@returns float Vektori kolmas koordinaat.
	*/
	public function getZ() {
	
		return $this->z;
	
	}
	
	/**
	*Vektori esimese koordinaadi seadmine.
	*@param float $x esimene koordinaat.
	*@returns void
	*/
	public function setX($x) {
	
		$this->x=$x;
	
	}
	
	/**
	*Vektori teise koordinaadi seadmine.
	*@param float $y teine koordinaat.
	*@returns void
	*/
	public function setY($y) {
	
		$this->y=$y;
	
	}
	
	/**
	*Vektori kolmanda koordinaadi seadmine.
	*@param float $z kolmas koordinaat.
	*@returns void
	*/
	public function setZ($z) {
	
		$this->z=$z;
	
	}
	
	/**
	*Vektori läbikorrutamine reaalarvuga.
	*@returns void
	*/
	public function mult($r) {
	
		$this->x*=$r;
		$this->y*=$r;
		$this->z*=$r;
	
	}
	
	/**
	*Vektori väljastamine. Mõeldud silumiseks.
	*@returns void
	*/
	public function output() {
	
		echo "(" .$this->x ."," .$this->y ."," .$this->z .")\r\n";
	
	}

}

/**
*Kahe vektori liitmine.
*@param Vector $v1 Esimene vektor.
*@param Vector $v2 Teine vektor.
*@returns Vector Antud vektorite summa vektor.
*/
function addVectors($v1, $v2) {

	return new Vector($v1->getX()+$v2->getX(), $v1->getY()+$v2->getY(), $v1->getZ()+$v2->getZ());

}

/**
*Kahe vektori skalaarkorrutis.
*@param Vector $v1 Esimene vektor.
*@param Vectot $v2 Teine vektor.
*@returns float Vektorite skalaarkorrutis.
*/
function dotProduct($v1, $v2) {

	return $v1->getX()*$v2->getX()+$v1->getY()*$v2->getY()+$v1->getZ()*$v2->getZ();

}

/**
*Kahe vektori vahelise nurga leidmine.
*@param Vector $v1 Esimene vektor.
*@param Vectot $v2 Teine vektor.
*@returns float Vektorite vaheline nurk radiaanides.
*/
function angle($v1, $v2) {

	return acos(dotProduct($v1, $v2)/($v1->getLength()*$v2->getLength()));

}

/**
*Vektori $v1 vektoriga $v2 paralleelse projektsiooni
*leidmine.
*@param Vector $v1 Esimene vektor.
*@param Vectot $v2 Teine vektor.
*@returns Vector Vektori $v1 projektsioon vektorile $v2.
*/
function projection($v1, $v2) {

	$v=clone $v2;
	$v->mult(dotProduct($v1, $v2));
	return $v;

}

/**
*Kahe vektori vektorkorrutis.
*@param Vector $v1 Esimene vektor.
*@param Vectot $v2 Teine vektor.
*@returns float Vektorite vektorkorrutis.
*/
function crossProduct($v1, $v2) {

	return new Vector(
		$v1->getY()*$v2->getZ() - $v2->getY()*$v1->getZ(),
		$v1->getZ()*$v2->getX() - $v2->getZ()*$v1->getX(),
		$v1->getX()*$v2->getY() - $v2->getX()*$v1->getY()
		);

}

?>