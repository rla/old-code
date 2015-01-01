<?php

/**
*Saidi abstarktsioon. Sait on üks lehtede kogum.
*Vajab SQL tabelit site:
*
*id int,
*name varchar,
*abs_path varchar,
*rel_path varchar
*
*@package Concise
*@subpackage Objects
*/

require_once("basicdb.php");
$page=0;

function outputpage() {

	global $page;
	$page->output();
	
}

/**
*Saidi objekt.
*/
class Site extends BasicDBObj {

	/**
	*Peakonstruktor.
	*@param int $id Saidi identifikaator.
	*@param int $userid Kasutaja identifikaator, vajalik audentimiseks.
	*Kasutaja identifikaatoriga 0 on superkasutaja ja tal on õigus igale saidile.
	*@param boolean $create_new Määrab, kas luuakse uus sait.
	*@returns void
	*/	
	public function __construct($id, $userid, $create_new=false) {
		
		parent::__construct('site', $id, $create_new);
	
	}
	
	/**
	*Saidi lehe sisu väljastamine
	*/
	function output() {
	
		global $page;
		$pid=$_POST[ID_ENTITY] or $pid=$_GET[ID_ENTITY] or $pid=$this->getProperty('default_page');
		$page=new SitePage($pid, $this);
		
		if (($t=$page->getProperty('template'))==0) outputpage();
		else {
			$template=new SitePage($t, $this);
			$template->output();
		}
	
	}

}

/**
*Saidi leht.
*/

class SitePage extends BasicDBObj {

	private $site=0;

	/**
	*Peakonstruktor.
	*@param int $id Lehe identifikaator
	*@param boolean $create_new Määrab, kas luuakse uus leht.
	*@returns void
	*/	
	public function __construct($id, $site, $create_new=false) {
		
		parent::__construct('sitepage', $id, $create_new);
		$this->site=$site;
	
	}
	
	/**
	*Sisu määramine.
	*/
	public function setContent($content, $type) {
	
		$this->setProperty('type', $type);
		if ($type=='php') {
			$fp=fopen($this->site->getProperty('abs_path') .'/php/' .$this->getId() .'.php', 'w');
			fwrite($fp, $content);
			fclose($fp);
		} else $this->setProperty('content', $content);
	
	}
	
	/**
	*Sisu väljastamine.
	*/
	public function output() {
	
		if ($this->getProperty('type')=='php') {
			include($this->site->getProperty('abs_path') .'/php/' .$this->getId() .'.php');
		} else echo $this->getProperty('content');
	
	}
	
}

?>