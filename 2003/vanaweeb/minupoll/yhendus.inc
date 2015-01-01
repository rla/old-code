<?

	$hostname="localhost";
	$username="jim17";
	$password="xxx";
	$database="minupoll";

	$link= mysql_connect($hostname, $username, $password) or die ("Ühenduse viga");
	mysql_select_db($database, $link) or die ("Andmebaasi viga");

?>