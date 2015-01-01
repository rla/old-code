<?php

/**
*PHP 3D vahendid. Maatriks ja tehted maatriksitega.
*
*@author Raivo Laanemets <rl@starline.ee>
*@copyright 2005 Raivo Laanemets
*/

require_once("vector.php");

class Matrix {

	private $m=0;
	private $n=0;
	private $matrix=array(array());

	/**
	*Uue m x n maatriksi loomine.
	*@param int $m Ridade arv.
	*@param int $n Veergude arv.
	*/
	public function __construct($m, $n) {
	
		$this->m=$m;
		$this->n=$n;
	
	}
	
	/**
	*Antud maatriksi determinandi leidmine Laplace'i teoreemil põhineva algoritmiga.
	*@returns float Antud maatriksi determinant.
	*/
	public function determinant() {
	
		return $this->det($this->matrix);
	
	}
	
	private function det($mat) {
	
		if (count($mat)==0) return 1;
		
		$sum=0;
		for ($i=0; $i<count($mat[0]); $i++) {
		
			$a=$mat[0][$i];
			
			//Loome uue maatriksi, eemaldame esimese rea ja $i-nda veeru.
			
			unset($mat2);
			for ($j=1; $j<count($mat); $j++) for ($k=0; $k<count($mat[$j]); $k++) if ($k!=$i) $mat2[$j-1][]=$mat[$j][$k];
			
			$det=$this->det($mat2);
			
			if ($i%2==0) $sum+=$a*$det; else $sum-=$a*$det;
		
		}
		
		return $sum;
	
	}
	
	/**
	*Antud maatriksi $i-nda rea $j-nda veeru elemendi seadmine.
	*@param int $i Rea indeks.
	*@param int $j Veeru indeks.
	*@param float $value elemendi väärtus.
	*@returns boolean true, kui operatsioon õnnestus.
	*/
	public function setElement($i, $j, $value) {
	
		if ($i>=$this->m || $j>=$this->n) return false;
		$this->matrix[$i][$j]=$value;
		return true;
	
	}
	
	/**
	*Antud maatriksi $i-nda rea $j-nda veeru elemendi saamine.
	*@param int $i Rea indeks.
	*@param int $j Veeru indeks.
	*@returns float Elemendi väärtus.
	*/
	public function getElement($i, $j) {
	
		return $this->matrix[$i][$j];
	
	}

	/**
	*Väljastab antud maatriksi sisu. Mõeldud vigade
	*silumiseks.
	*/
	public function output() {
	
		for ($i=0; $i<$this->m; $i++) {
		
			for ($j=0; $j<$this->n; $j++) echo $this->matrix[$i][$j] ."\t";
			echo "\r\n";
			
		}
	
	}
	
	/**
	*Antud maatriksi ridade arvu saamine.
	*@returns int Antud maatriksi ridade arv.
	*/
	public function getM() {
	
		return $this->m;
	
	}
	
	/**
	*Antud maatriksi veergude arvu saamine.
	*@returns int Antud maatriksi veergude arv.
	*/
	public function getN() {
	
		return $this->n;
	
	}
	
	/**
	*Maatriksi otse määramine etteantud massiiviga.
	*NB! Mingit kontrolli ei toimu, kas etteantud maatriks vastab
	*antud maatriksi kõrgusele ja laiusele.
	*/
	public function setMatrix($matrix) {
	
		$this->matrix=$matrix;
	
	}

}

/**
*Kahe maatriksi korrutise leidmine.
*@param Matrix $m1 Esimene maatriks.
*@param Matrix $m2 Teine maatriks.
*@returns Matrix Antud maatriksite korrutis.
*/
function matrixMult($m1, $m2) {

	if ($m1->getN()!=$m2->getM()) die('Antud maatrikseid ei ole võimalik korrutada!');
	
	$m=new Matrix($m1->getM(), $m2->getN());
	
	for ($i=0; $i<$m1->getM(); $i++) for ($j=0; $j<$m2->getN(); $j++) {
	
		$e=0;
		for ($k=0; $k<$m->getN(); $k++) $e+=$m1->getElement($i, $k)*$m2->getElement($k, $j);
		$m->setElement($i, $j, $e);
	
	}
	
	return $m;

}

?>