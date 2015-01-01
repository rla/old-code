<?php

/*
teesait.php
Saidi vajalike failide kopeerimine ja andmebaasi andmete lisamine.
Raivo Laanemets
25. juuli 2004
09. august 2004 - Kasutaja peab failid ise kopeerima ning algosad installeerima.
*/

//Tabeli loomine templeitide jaoks.
mysql_query("CREATE TABLE " .$_POST['nimi'] ."_templeidid (
  id char(20) PRIMARY KEY,
  tekst text)
") or print mysql_error();

//Moodulite tabeli loomine

mysql_query("CREATE TABLE " .$_POST['nimi'] ."_moodulid (
  id char(20) PRIMARY KEY,
  mis char(20)
  )
");

//Kirje lisamine administeerimissüsteemi saidi olemasolu kohta
if (mysql_query("INSERT INTO saidid VALUES(0, '" .$_POST['nimi'] ."', '../" .$_POST['tee'] ."', '" .$_POST['base'] ."')")) print 'Sait lisatud';

?>