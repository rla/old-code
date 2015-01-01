<html>
<head>
<title>Lingikogu</title>

<style>
	.tabel
	{
	font-family: verdana;
	font-size: 11px;
	color: #6666cc;
	}
	.lisa
	{
	font-family: arial;
	font-weight: bold;
	font-size: 12px;
	{
</style>

</head>
<body>

<table cellspacing="1" cellpadding="2">
<?php

	$host="localhost";
	$kasutajanimi="jim17";
	$parool="xxx";
	$baas="jim17";
	$tabel="lingikogu";

	$link=mysql_connect($host, $kasutajanimi, $parool);//ühendame
	mysql_select_db($baas, $link);//valime andmebaasi

	$kask="select link, kirjeldus, nimi, aeg from lingikogu order by id desc";

	$result=mysql_query($kask, $link);

	$bgcolor="\"#eeeeee\"";//tabeli rea tausta värv

	while ($rida=@mysql_fetch_assoc($result)) 
		{
		echo "<tr><td bgcolor=", $bgcolor, " class=\"tabel\">", $rida['nimi'], "</td>\n";
		echo "<td bgcolor=", $bgcolor, " class=\"tabel\"><a href=\"", $rida['link'], "\">", $rida['link'], "</a></td>\n";
		echo "<td bgcolor=", $bgcolor, " class=\"tabel\">", $rida['kirjeldus'], "</td></tr>\n";
		}

	mysql_close($link);

?>
</table>

</body>
</html>