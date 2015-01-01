<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
  <title>Uue tabeli loomine</title>
  <meta name="Description" content="Uue tabeli loomine">
  <meta name="Author" content="Raivo Laanemets">
  <meta name="Copyright" content="(c) 2005 Raivo Laanemets">
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-13">
  <style type="text/css">
  body, li, i, h1, h2, h3, h4, h5, p, td {
    font-family: Helvetica, sans-serif;
  }
  td {
    padding: 6px;
  }
  </style>
  </head>
<body style="width:600px">
<h1>Uue arvutustabeli loomine</h1>
<h2>Tabeli salvestamine</h2>

<?php

/*
MySql t_kirjeldused struktuur:

id,
nimi,
v_arv,

MySql t_veerud struktuur:

id,
tabel,
nimi,
valem

*/

require("mysql.php");
require("new_table.form.php");

if (mysql_query("INSERT INTO t_kirjeldused (nimi, v_arv) VALUES('" .mysql_escape_string($_POST['name']) ."', " .$_POST['cols'] .")"))
	echo '<span style="color:green">Tabeli kirjeldus lisatud</span><br>';
	else die('<span style="color:red">VIGA! ' .mysql_error() .'</span><br>');
	
$id=mysql_insert_id();
$sql="CREATE TABLE `" .$_POST['name'] ."` (id int auto_increment, ";

for ($i=1; $i<=$_POST['cols']; $i++) {

	if(mysql_query("INSERT into t_veerud (tabel, nimi, valem) VALUES(" .$id .", '" .mysql_escape_string($_POST['v'.$i]) ."', '" .mysql_escape_string($_POST['v'.$i.'f']) ."')"))
		echo '<span style="color:green">Veeru kirjeldus lisatud</span><br>';
	else die('<span style="color:red">VIGA! ' .mysql_error() .'</span><br>');
	
	$sql.="`" .$_POST['v'.$i] ."` varchar(255)";
	if ($i<$_POST['cols']) $sql.=", "; else $sql.=", PRIMARY KEY(id))";
	
}

echo '<br>Uue tabeli SQL: ' .$sql .'<br><br>';

if (mysql_query($sql)) echo '<span style="color:green">Uus tabel edukalt loodud!</span><br>';
	else echo '<span style="color:red">VIGA! ' .mysql_error() .'</span><br>';
	
$fp=fopen($_POST['name'] .'.insert.php', 'w');

fwrite($fp, $header);

fwrite($fp, '<h1>Andmete sisestamine tabelisse "' .$_POST['name'] .'"</h1><form method="post" action="' .$_POST['name'] .'.insert2.php">');

for ($i=1; $i<$_POST['cols']; $i++) {

	if (!$_POST['v'.$i.'f']) fwrite($fp, '<label for="v' .$i .'">' .$_POST['v'.$i] .'</label><br><input type="text" name="v' .$i .'"><br>');

}

fwrite($fp, '<br><input type="submit" value="Lisa"></form>');
fwrite($fp, $footer);

fclose($fp);

?>

<p><i>Autor: Raivo Laanemets, <a href="mailto:rlaanemt@ut.ee">rlaanemt@ut.ee</a><br>
Copyright (c) 2005 Raivo Laanemets<br>
<p>
<a href="http://validator.w3.org/check?uri=referer"><img
  src="http://www.w3.org/Icons/valid-html401"
  alt="Valid HTML 4.01!" height="31" width="88"></a>
</p>
</body>
</html>