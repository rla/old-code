<?php
	include("db_conf.inc");

	mysql_connect($host, $user, $pass) or
		die ("Ei suutnud ühenduda andmebaasiga");

	mysql_select_db("questbook") or
		die ("Andmebaasi viga");

	if ($submit=="Ok")
		{
		$query="insert into guestbook"
		}
?>