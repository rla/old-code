<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>Guest managed address book</title>
</head>
<body>
<h1>Aadressiraamat</h1>
<?php
mysql_connect("localhost", "d6349sa7045", "Diablo666") or die(mysql_error()); 
mysql_select_db("d6349sd4071"); 

sleep(5);
@mysql_query("INSERT INTO friends (
	eesnimi,
	perenimi,
	s_kuu,
	s_paev,
	s_aasta,
	address,
	telephone,
	email,
	web,
	msn
	) VALUES (
	'" .mysql_escape_string($_POST['eesnimi']) ."',
	'" .mysql_escape_string($_POST['perenimi']) ."',
	'" .mysql_escape_string($_POST['s_kuu']) ."',
	'" .(int)$_POST['s_paev'] ."',
	'" .(int)$_POST['s_aasta'] ."',
	'" .mysql_escape_string($_POST['address']) ."',
	'" .mysql_escape_string($_POST['telephone']) ."',
	'" .mysql_escape_string($_POST['email']) ."',
	'" .mysql_escape_string($_POST['web']) ."',
	'" .mysql_escape_string($_POST['msn']) ."'
	)
");

mysql_close();
?>
<p>Tänan, sissekanne lisatud!</p>
</body>
</html>