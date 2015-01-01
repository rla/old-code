<?php

/**
*Graafikute joonistamise klass.
*@author Raivo Laanemets
*@copyright 2005 Raivo Laanemets
*/

class Graph {

	/**Graafiku pilt*/
	var $img=null;
	
	/**Graafiku laius pikslites*/
	var $width=0;
	
	/**Graafiku kõrgus pikslites*/
	var $height=0;
	
	/**x-telje mõõtkava*/
	var $range_x=0;
	
	/**y-telje mõõtkava*/
	var $range_y=0;
	
	/**Joonistamise värv, vaikimisi must*/
	var $color=0;

	/**
	*Graafiku konstruktor.
	*@param $width graafiku laius pikslites
	*@param $height graafiku kõrgus pikslites
	*@param $range_x x-telje mõõtkava, sümmeetriline
	*@param $range_y y-telje mõõtkava, sümmeetriline
	*@param $filename fail, kuhu graafik salvestatakse
	*/
	function Graph($width, $height, $range_x, $range_y, $filename) {
	
		$this->width=$width;
		$this->height=$height;
		
		$this->range_x=$range_x;
		$this->range_y=$range_y;
		
		$this->filename=$filename;
		
		$this->img=ImageCreateTrueColor($width, $height);
		
		//Graafiku taust valgeks.
		ImageFill($this->img, 0, 0, $this->Color(255, 255, 255));
	
	}
	
	/**
	*Pildimälu puhastamine ja graafiku
	*salvestamine faili.
	*/
	function Close() {
	
		ImagePng($this->img, $this->filename);
		ImageDestroy($this->img);
	
	}
	
	/**
	*Graafikule telgede joonistamine.
	*/
	function DrawAxis() {
	
		//Teljed
		ImageLine($this->img, $this->width/2, 0, $this->width/2, $this->height, $this->color);
		ImageLine($this->img, 0, $this->height/2, $this->width, $this->height/2, $this->color);
		
		//Telgede tõkkeväärtused
		ImageString($this->img, 2, $this->width/2+10, 0, $this->range_y, $this->color);
		ImageString($this->img, 2, $this->width/2+10, $this->height-20, -($this->range_y), $this->color);
		
		ImageString($this->img, 2, 0, $this->height/2-20, -($this->range_x), $this->color);
		ImageString($this->img, 2, $this->width-40, $this->height/2-20, $this->range_x, $this->color);
		
		//Nullpunkt
		ImageString($this->img, 2, $this->width/2-20, $this->height/2+10, "0", $this->color);
	
	}
	
	/**
	*Värvi moodustamine kolmest põhivärvist.
	*@param $r punase värvi osakaal 0..255
	*@param $g rohelise osakaal 0..255
	*@param $b sinise osakaal 0..255
	*/
	function Color($r, $g, $b) {
	
		return ImageColorAllocate($this->img, $r, $g, $b);
	
	}
	
	/**
	*Joonistaja värvi seadmine.
	*@param $r punase värvi osakaal 0..255
	*@param $g rohelise osakaal 0..255
	*@param $b sinise osakaal 0..255
	*/
	function SetColor($r, $g, $b) {
	
		$this->color=$this->Color($r, $g, $b);
	
	}
	
	/**
	*Horisontaalkoordinaadi teisendus PHP GD koordinaadistikku.
	*@param $x koordinaadi x väärtus loodud koordinaatsüsteemis.
	*/
	function TransformX($x) {
	
		return floor((1+$x/$this->range_x)*$this->width/2);
	
	}
	
	/**
	*Vertikaalkoordinaadi teisendus PHP GD koordinaadistikku.
	*@param $y koordinaadi y väärtus loodud koordinaatsüsteemis.
	*/
	function TransformY($y) {
	
		return floor((1-$y/$this->range_y)*$this->height/2);
	
	}
	
	/**
	*Punkti joonistamine.
	*@param $x antud punkti x koordinaat arvestades loodud koordinaatsüsteemi.
	*@param $y antud punkti y koordinaat arvestades loodud koordinaatsüsteemi.
	*@param $label punkti juurde paremale üles kirjutatav tekst.
	*/
	function DrawDot($x, $y, $label="") {
	
		//Koordinaatide teisendus PHP GD koordinaadistikku.
		$x_1=$this->TransformX($x);
		$y_1=$this->TransformY($y);
		
		//Punkti joonistamine
		ImageSetPixel($this->img, $x_1, $y_1, $this->color);
		
		//Punkti tähistus
		if ($label!="") ImageString($this->img, 2, $x_1+10, $y_1-10, $label, $this->color);
	
	}
	
	/**
	*Punkti joonistamine polaarkoordinaatides.
	*@param $r raadius.
	*@param $a nurk.
	*@param $label punkti juurde kirjutatav tekst.
	*/
	function DrawParametricDot($r, $a, $label) {
	
		//Teisendus tavakoordinaatideks
		//ja tavakoordinaatides punkti joonistamine
		$this->DrawDot($r*cos($a), $r*sin($a), $label);
	
	}
	
	/**
	*Polaarkoordinaatides antud sirge joonistamine.
	*/
	function DrawParametricLine($r_0, $a_0, $r_1, $a_1) {
	
		//Teisendus tavakoordinaatideks ja sirge joonistamine.
		$this->DrawLine($r_0*cos($a_0), $r_0*sin($a_0), $r_1*cos($a_1), $r_1*sin($a_1));
	
	}
	
	/**
	*Sirglõigu joonistamine.
	*@param $x_0 lõigu alguspunkti x koordinaat.
	*@param $y_0 lõigu alguspunkti y koordinaat.
	*@param $x_1 lõigu lõpp-punkti x koordinaat.
	*@param $y_1 lõigu lõpp-punkti y koordinaat.
	*@param $label lõigu tähistus.
	*/
	function DrawLine($x_0, $y_0, $x_1, $y_1, $label="") {
	
		//Koordinaatide teisendus
		$x_0=$this->TransformX($x_0);
		$y_0=$this->TransformY($y_0);
		
		$x_1=$this->TransformX($x_1);
		$y_1=$this->TransformY($y_1);
		
		//Lõigu joonistamine
		ImageLine($this->img, $x_0, $y_0, $x_1, $y_1, $this->color);
	
	}
	
	/**
	*Funktsiooni $func graafiku joonistamine
	*@param $func joonistatav funktsioon.
	*@param $x_min alumine argumendi väärtuste piir.
	*@param $x_max ülemine argumendi väärtuste piir.
	*/
	function DrawFunction($func, $x_min, $x_max) {
	
		//x koordinaadi sammu leidmine.
		$step=2*$this->range_x/$this->width;
	
		$x=$x_min;
		
		//Joone algpunkt
		$x_0=$x_min;
		$y_0=$func($x_0);
		
		//Graafiku moodustamine lõikudest.
		while ($x<=$x_max) {
		
			//Leiame uued x, y väärtused
			$x+=$step;
			$y=$func($x);
			
			//Joonistame ühe lõigu
			$this->DrawLine($x_0, $y_0, $x, $y);
			
			//Anname joone alguspunktile uue väärtuse
			$x_0=$x;
			$y_0=$y;
		
		}
	
	}
	
	/**
	*Parameetriliselt antud funktsiooni joonistamine.
	*@param $x_func funktsioon x=x(t).
	*@param $y_func funktsioon y=y(t).
	*@param $t_min t alumine väärtus.
	*@param $t_max t ülemine väärtus.
	*/
	function DrawParametricFunction($x_func, $y_func, $t_min, $t_max) {
	
		//t sammu arvutamine. Ühtne valem puudub,
		//jagame t piirkonna 2000 alampiirkonnaks.
		$step=($t_max-$t_min)/2000;
		
		$t=$t_min;
		
		//Algpunkt
		$x_0=$x_func($t);
		$y_0=$y_func($t);
		
		while ($t<=$t_max) {
		
			$t+=$step;
		
			$x=$x_func($t);
			$y=$y_func($t);
			
			$this->DrawLine($x_0, $y_0, $x, $y);
			
			$x_0=$x;
			$y_0=$y;
		
		}
	
	}
	
	/**
	*Polaarkoordinaatides antud funktsiooni r=r(phi) graafiku joonistamine.
	*@param $r_func funktsioon r=r(phi).
	*@param $phi_min phi alumine väärtus.
	*@param $phi_max phi ülemine väärtus.
	*/
	function DrawPolarFunction($r_func, $phi_min, $phi_max) {
	
		//phi sammu arvutamine. Ühtne valem puudub,
		//jagame phi piirkonna 2000 alampiirkonnaks.
		$step=($phi_max-$phi_min)/2000;
		
		$phi=$phi_min;
		
		//Algpunkt
		$r_0=$r_func($phi);
		$phi_0=$phi;
		
		while ($phi<=$phi_max) {
		
			$phi+=$step;
		
			$r=$r_func($phi);
			
			$this->DrawParametricLine($r_0, $phi_0, $r, $phi);
			
			$r_0=$r;
			$phi_0=$phi;
		
		}
	
	}
	
}

?>