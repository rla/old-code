<?php

/**
*Database to RSS file.
*
*@author Raivo Laanemets <rlaanemt@ut.ee>
*@version 1.0
*@licence You can use this script for any purpose. (aka Public Domain).
*/

/**Set up MySql connection*/
require_once("mysql.php");

//Dumping from database

$feed=new DOMDocument('1.0', 'utf-8');
$rss=$feed->createElement('rss');
$rss->setAttribute('version', '0.91');
$feed->appendChild($rss);

//Iterate over channels

$res=mysql_query("SELECT * FROM channels ORDER BY title");
while ($result=mysql_fetch_array($res)) {

	$channel=$feed->createElement('channel');
	
	$channel->appendChild($feed->createElement('title', $result['title']));
	$channel->appendChild($feed->createElement('link', $result['link']));
	$channel->appendChild($feed->createElement('description', $result['description']));
	$channel->appendChild($feed->createElement('language', $result['language']));
	
	//Iterate over items
	
	$itres=mysql_query("SELECT title, link, description FROM items WHERE new='y' ORDER BY `date`") or die(mysql_error());
	while ($it=mysql_fetch_array($itres)) {
	
		$item=$feed->createElement('item');
		$item->appendChild($feed->createElement('title', $it['title']));
		$item->appendChild($feed->createElement('link', $it['link']));
		$item->appendChild($feed->createElement('description', $it['description']));
		
		$channel->appendChild($item);
	
	}
	
	$rss->appendChild($channel);
	
}

//Saving the document

$feed->save('rss.xml');

?>