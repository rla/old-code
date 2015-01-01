<?php
if ((strlen($nimi)>0) && (strlen($link)>0) && (strlen($kirjeldus)>0))
	{
		
	$host="localhost";
	$kasutajanimi="jim17";
	$parool="xxx";
	$baas="jim17";

	$reslink=mysql_connect($host, $kasutajanimi, $parool);//ühendame
	mysql_select_db($baas, $reslink);//valime andmebaasi

	$kask="INSERT INTO lingikogu VALUES (0, '$nimi', '$kirjeldus', '$link', now())";
	
	mysql_query($kask, $reslink);

	mysql_close($reslink);
	}
?>