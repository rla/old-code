<html>
<head>
<title>Küsimuse lisamine</title>
</head>
<body>
<?

	if (strlen($kysimus)>0)
		{ 		

		$hostname="localhost";
		$username="jim17";
		$password="xxx";
		$database="minupoll";

		$link= mysql_connect($hostname, $username, $password) or die ("Ühenduse viga");
		mysql_select_db($database, $link) or die ("Andmebaasi viga");
		
		$query1="INSERT INTO kysimused VALUES (0, '$kysimus', now())";
		mysql_query($query1, $link) or die ("Ei saanud lisada küsimust!");

		$vastarv=0;//vastuste arv
		if (strlen($vas1)>0) $vastarv=1;
		if (strlen($vas2)>0) $vastarv=2;
		if (strlen($vas3)>0) $vastarv=3;
		if (strlen($vas4)>0) $vastarv=4;
		if (strlen($vas5)>0) $vastarv=5;
		if (strlen($vas6)>0) $vastarv=6;
		if (strlen($vas7)>0) $vastarv=7;
		if (strlen($vas8)>0) $vastarv=8;
		if (strlen($vas9)>0) $vastarv=9;
		if (strlen($vas10)>0) $vastarv=10;

		$query2="INSERT INTO vastused VALUES (0, '$vas1', '$vas2', '$vas3', '$vas4', '$vas5', '$vas6', '$vas7', '$vas8', '$vas9', '$vas10', '$vastarv')";
		mysql_query($query2, $link) or die ("Ei saanud lisada vastuseid!");

		$n=0;//täisarv 0

		$query3="INSERT INTO haaled VALUES (0, '$n', '$n', '$n', '$n', '$n', '$n', '$n', '$n', '$n', '$n')";
		mysql_query($query3, $link) or die ("Ei saanud nullida hääli!");

		mysql_close($link); //sulgeme ühenduse

		}
		else
		{
		echo "Küsimuse väli pole täidetud";
		}

?>
</body>
</html>