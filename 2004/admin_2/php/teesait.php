<?php

/*
teesait.php
Saidi vajalike failide kopeerimine ja andmebaasi andmete lisamine.
Raivo Laanemets
25. juuli 2004
*/

//1. Saidile uue kausta loomine
$kaust='../' .$_POST['tee']; mkdir($kaust); chmod($kaust, 0777);

//2. Failide kopeerimine
$kaustad=array('lib', 'php');
foreach($kaustad as $value) {
	mkdir($kaust .'/' .$value); chmod($kaust .'/' .$value, 0777);
}

$failid=array('index.php', 'php/main.php', 'lib/main.php', 'conf.php');
foreach($failid as $value) copy('uus-sait/' .$value, $kaust .'/' .$value);

//3. Tabeli loomine ja indekslehekülje lisamine
mysql_select_db($_POST['base']);

print 'SAIDI NIMI: ' .$_POST['nimi'] .'<br>';
print 'ANDMEBAAS: ' .$_POST['base'] .'<br>';

mysql_query(
  "CREATE TABLE " .$_POST['nimi'] ."_sisu (
  id varchar(50) primary key NOT NULL default '',
  text text NOT NULL,
  tyyp set('html','thtml','text','css','php') NOT NULL default '',
  title varchar(110) NOT NULL default '',
  keel varchar(2) NOT NULL default 'ee'
  ) TYPE=MyISAM") or print mysql_error();
mysql_query(
  "CREATE TABLE " .$_POST['nimi'] ."_lehed (
  id varchar(50) primary key NOT NULL default '') TYPE=MyISAM"
  ) or print mysql_error();
mysql_query(
  "CREATE TABLE " .$_POST['nimi'] ."_templeidid (
  id varchar(50) NOT NULL default '',
  tekst text,
  PRIMARY KEY  (id))
  TYPE=MyISAM;") or print mysql_error();

mysql_query("INSERT INTO " .$_POST['nimi'] ."_sisu VALUES ('main', '', 'php', '', '')");
mysql_query("INSERT INTO " .$_POST['nimi'] ."_sisu VALUES ('index', 'Uus lehekülg loodud.', 'html', 'Avalehekülg', 'ee')");
mysql_query("INSERT INTO " .$_POST['nimi'] ."_lehed VALUES ('index')");
mysql_query("INSERT INTO " .$_POST['nimi'] ."_templeidid VALUES ('default', '')");
mysql_select_db($_SESSION['baas']);

//4. Kirje lisamine administeerimissüsteemi saidi olemasolu kohta
if (mysql_query("INSERT INTO saidid VALUES(0, '" .$_POST['nimi'] ."', '../" .$_POST['tee'] ."', '" .$_POST['base'] ."')")) print 'Sait lisatud';

?>