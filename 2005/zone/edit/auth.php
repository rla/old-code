<?php

/**
*Audentimine.
*
*Reserveerib järgmised sessioonimuutujad: 
*$_SESSION['user'].
*
*Vajab käsitsi seadmist järgmistele parameetritele: 
*superkasutaja parool, superkasutaja lubamine.
*
*@package Concise
*@author Raivo Laanemets <rlaanemt@ut.ee>
*@license http://opensource.org/licenses/gpl-license.php GNU Public License
*@version 1.01
*@filesource
*@todo Meetodid realiseerida.
*/

/**Superkasutaja parool*/
define('ROOTPASS', 'enter');

/**Superkasutaja lubamine-antud konstandi väärtus true*/
define('ROOT', true);

/**
*Kapseldab audentimiseks vajalikud meetodid.
*/
class Auth {
	
	/**@access private*/
	var $user=9999;
	
	/**@access private*/
	var $authed=false;
	
	/**@access private*/
	var $group=9999;
	
	/**
	*Audentimine.
	*Kasutajate lisamiseks, kustutamiseks jms. on vajalik
	*audentimine superkasutajana.
	*
	*Audentimiseks vajalik info võetakse automaatselt
	*sessioonimuutujatest, seetõttu on vajalik lause session_start()
	*olemasolu.
	*/
	function Auth() {
	
		if (isset($_SESSION['user'])) {
			//Kasutaja on arvatavasti korra sisse loginud.
			$this->authed=true;
			$this->user=$_SESSION['user'];
			return;
		} else {
			//Kasutaja logib sisse antud hetkel.
			$username=$_POST['user'];
			$password=$_POST['pass'];
			//Kontrollime kasutaja olemasolu ja parooli.
		}
	
		if ($username=='root' && $password==ROOTPASS && ROOT) {
			//Kasutaja on superkasutaja (root)
			$this->authed=true;
			$this->group=0;
			$this->user=0;
			$_SESSION['user']=0;
		}
	
	}
	
	/**
	*Kontroll, kas kasutaja on audentitud.
	*@returns boolean True-kasutaja on audentitud, false-kasutaja pole audentitud.
	*/
	function isAuthed() {
	
		return $this->authed;
	
	}
	
	/**
	*Välja logimine.
	*@returns void
	*/
	function logout() {
	
		$this->user=9999;
		$this->group=9999;
		$this->authed=false;
		unset($_SESSION['user']);
	
	}
	
	/**
	*Kontroll, kas antud kasutaja on superkasutaja (root)
	*@returns boolean True-antud kasutaja on superkasutaja, false-antud kasutaja
	*ei ole superkasutaja.
	*/
	function isRoot() {
	
		return !$this->user;
	
	}
	
	/**
	*Uue kasutaja lisamine.
	*Kasutajat saab lisada vaid superkasutajana audentinud isik.
	*
	*@param string $username Loodava kasutaja kasutajanimi.
	*
	*Nõuded kasutajanimele: soovitavalt sisaldab ainult ladina tähti
	*(nii suuri kui väikeseid). Ei tohi sisaldada tühikut ega erimärke. Lubatud
	*on alakriipsu _ ja numbrite kasutamine.
	*
	*@param string $password Kasutaja parool.
	*
	*Nõuded paroolile: soovitavalt koosneb ainult ladina tähtedest
	*(kusjuures sisaldab korraga nii väikeseid kui suuri tähti). Sisaldab
	*lisaks tähtedele ka numbreid, aga ei tohiks sisaldada erimärke v.a alakriips _.
	*
	*@returns boolean Kui kasutaja lisamine õnnestus, siis tagastab true,
	*vastasel korral false.
	*/
	function addUser($username, $password) {
	
		if (!$this->isRoot()) return false;
	
	}
	
	/**
	*Olemasoleva kasutaja kustutamine.
	*Kasutajat saab kustutada vaid superkasutajana audentinud isik.
	*
	*@param string $username Kustutatava kasutaja nimi.
	*
	*@return boolean True, kui kasutaja kustutamine õnnestus, false,
	*kui kasutajat ei saanud kustutada.
	*/
	function deleteUser($username) {
	
		if (!$this->isRoot()) return false;
	
	}
	
	/**
	*Uue kasutajagrupi lisamine.
	*
	*@param string $name Loodava grupi nimi.
	*
	*Nõuded grupi nimele: soovitavalt sisaldab ainult ladina tähti
	*(nii suuri kui väikeseid). Ei tohi sisaldada tühikut ega erimärke. Lubatud
	*on alakriipsu _ ja numbrite kasutamine.
	*
	*@param string $description Grupi lühike kirjeldus.
	*
	*@returns boolean True, kui grupi lisamine õnnestus, false, kui gruppi ei saanud lisada.
	*/
	function addGroup($name, $description) {
	
		if (!$this->isRoot()) return false;
	
	}
	
	/**
	*Olemasoleva kasutajate grupi kustutamine.
	*Gruppi saab kustutada vaid superkasutajana audentinud isik.
	*
	*@param string $name Kustutatava grupi nimi.
	*
	*@return boolean True, kui grupi kustutamine õnnestus, false,
	*kui gruppi ei saanud kustutada.
	*/
	function deleteGroup($name) {
	
		if (!$this->isRoot()) return false;
	
	}
	
	/**
	*Kasutaja lisamine uude gruppi.
	*Kasutajat saab uude gruppi lisada vaid superkasutaja (root).
	*
	*@param string $name Grupi nimi.
	*
	*@returns boolean True, kui kasutaja lisamine gruppi õnnestus, false, kui gruppi ei saanud lisada.
	*/
	function addUserGroup($name) {
	
		if (!$this->isRoot()) return false;
	
	}
	
	/**
	*Kasutaja eemaldamine antud grupist.
	*Kasutajat saab grupist eemaldada vaid superkasutaja (root).
	*
	*@param string $name Grupi nimi, kust antud kasutaja eemaldatakse.
	*
	*@return boolean True, kui grupist eemaldamine õnnestus, false,
	*kui grupist ei saanud eemaldada.
	*/
	function deleteUserGroup($name) {
	
		if (!$this->isRoot()) return false;
	
	}
	
	/**
	*Antud kasutaja identifikaatori saamine.
	*@returns int Antud kasutaja identifikaator.
	*/
	function getUserId() {
		
		return $this->user;
	
	}

}

?>