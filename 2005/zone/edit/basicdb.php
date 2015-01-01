<?php

/**
*Algobjektid. PHP 4 versioon.
*
*@package Concise
*@author Raivo Laanemets <rlaanemt@ut.ee>
*@license http://opensource.org/licenses/gpl-license.php GNU Public License
*@version 1.0
*@filesource
*/

/**
*Andmebaasiga suhtlevate objektide alusklass.
*/
class BasicDBObj {

	/**@access private*/
	var $id=0;
	
	/**@access private*/
	var $type='basic';
	
	/**@access private*/
	var $error='';
	
	/**
	*Konstruktor.
	*Iga antud klassi alamklassina kasutav klass peab
	*seda konstruktorit välja kutsuma.
	*@param string $type Objekti tüüp.
	*@param int $id Objekti identifikaator (ei arvestata uue loomisel!).
	*@param boolean $create_new Kui true, siis luuakse uus objekt.
	*/
	function BasicDBObj($type, $id, $create_new=false) {
	
		if ($create_new) {		
			mysql_query("INSERT INTO `" .$type ."` () VALUES ()");
			$this->type=$type;
			$this->id=mysql_insert_id();
		} else {
			$this->id=$id;
			$this->type=$type;
		}
		
		return true;
		
	}
	
	/**
	*Objekti identifikaatori saamine.
	*@returns int Objekti identifikaator.
	*/
	function getId() {
	
		return $this->id;
	
	}
	
	/**
	*Objekti tüübi saamine.
	*@returns string Objekti tüüp.
	*/
	function getType() {
	
		return $this->type;
	
	}
	
	/**
	*Antud objekti parameetri väärtuse seadmine.
	*@param string $name Parameetri nimi.
	*@param mixed $value Parameetri väärtus.
	*@returns boolean =true, kui operatsioon õnnestus.
	*/
	function setProperty($name, $value) {
	
		if (@mysql_query("UPDATE `" .$this->type ."` set " .$name ."='" .$value ."' WHERE id=" .$this->id)) return true;
		else {
			$this->error=mysql_error();
			return false;
		}
	
	}
	
	/**
	*Antud objekti parameetri väärtuse saamine.
	*@param string $name parameetri nimi.
	*@returns mixed Parameetri väärtus.
	*/
	function getProperty($name) {
	
		$res=mysql_query("SELECT `" .$name ."` FROM `" .$this->type ."` WHERE id=" .$this->id);
		if ($r=@mysql_fetch_row($res)) return $r[0];
		else {
			$this->error=mysql_error();
			return false;
		}
	
	}
	
	/**
	*Antud objekti iseloomustavate parameertite (kõigi) saamine.
	*@returns array Antud objekti kõik parameetrid.
	*/
	function getArray() {
	
		$res=mysql_query("SELECT * FROM `" .$this->type ."` WHERE id=" .$this->id);
		if ($r=@mysql_fetch_array($res)) return $r;
		else {
			$this->error=mysql_error();
			return false;
		}
	
	}
	
	/**
	*Alamobjekti lisamine. Vajab tabeli <antud tüüp>_ob olemasolu.
	*@param BasicDBObj $child lisatav alamobjekt.
	*@returns boolean =true, kui operatsioon õnnestus.
	*/
	function addChild($child) {
	
		if (mysql_query("INSERT INTO `" .$this->type ."_ob` (parent, type, object) VALUES (" .$this->id .", '" .$child->getType() ."', " .$child->getId() .")")) return true;
		else {
			$this->error=mysql_error();
			return false;
		}
	
	}
	
	/**
	*Tagastab antud objekti alamobjektid objektide viitade ja tüüpide massiivina.
	*@returns array Objektide viitade ja tüüpide massiiv
	*/
	function getChilds() {
	
		$obs=array();
		$res=mysql_query("SELECT type, object FROM `" .$this->type ."_ob` WHERE parent=" .$this->id);
		while ($result=mysql_fetch_array($res)) {
			$obs[]=$result;
		}
		
		return $obs;
	
	}
	
	function getChildIterator() {
	
		return new ChildIterator($this->type, $this->id);
	
	}
	
	/**
	*Viimati tekkinud veaolukorra teate tagastamine.
	*@returns string Viimase vea kirjeldus.
	*/
	function getLastError() {
	
		return $this->error;
	
	}

}

/**
*Objektide iteraator.
*/
class ObjectIterator {

	var $res=0;
	var $type=0;

	function ObjectIterator($type, $where='') {
	
		$this->res=mysql_query("SELECT id FROM `" .$type ."` " .$where ." ORDER BY id");
		$this->type=$type;
	
	}
	
	function next() {
	
		if ($id=mysql_fetch_row($this->res)) {
			return new BasicDBObj($this->type, $id[0]);
		} else return false;
	
	}

}

class ChildIterator {

	var $res=0;
	
	function ChildIterator($type, $id) {
	
		$this->res=mysql_query("SELECT id, type FROM `" .$type ."_ob` WHERE parent=" .$id ." ORDER BY id");
		
	}
	
	function next() {
	
		if ($row=mysql_fetch_row($this->res)) {
			return new BasicDBObj($row[1], $row[0]);
		} else return false;
		
	}
	
}

?>