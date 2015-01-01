<?php

/**
*Kaugdomeeni info. Domeeni saitide nimekirja väljastamine.
*
*@package Concise
*@subpackage Remote
*@author Raivo Laanemets <rl@starline.ee>
*@version 1.0
*/

define('MAX_STORAGE', 500000000);

session_start();
require_once("mysql.php");
require_once("auth.php");
require_once("basicdb.php");
$auth=new Auth();

//if (!$auth->isRoot()) die('You need root permissions to see remote domain statistics.');

/**
*Andmebaasi suuruse saamine.
*/
function dbsize() {

	$rows=mysql_query("SHOW TABLE STATUS"); 
	$dbsize=0; 
	while ($row=mysql_fetch_array($rows)) $dbsize+=$row['Data_length']+$row['Index_length'];
	return $dbsize;
	
}

/**
*Kettakasutuse suuruse saamine.
*/
function disksize($root='.') {

	if (is_file($root)) return filesize($root);

	$sum=0;
	$d=dir($root);
	while ($entry=$d->read()) if ($entry!='.' && $entry!='..') $sum+=disksize($root .'/' .$entry);
	$d->close();
	return $sum;

}

?>

<h1>Concise remote domain statistics</h1>
<h2>Storage resources</h2>
<?php

echo '<p class="general_p">
Database size: ' .dbsize() .' bytes<br>
Disk usage: ' .disksize('/data01/virt7170/domeenid/www.rl.pri.ee/') .' bytes<br>
</p>';

$it=new ObjectIterator('site');
while ($ob=$it->next()) {

	echo '<h2>Site: ' .$ob->getProperty('name') .'</h2>
	<p class="site_p">
	Created on: ' .$ob->getProperty('created') .'<br>
	</p>';
	
}

?>