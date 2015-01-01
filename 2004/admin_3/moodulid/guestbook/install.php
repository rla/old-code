<?php

/*
moodulid/guestbook/install.php
Külalisteraamatu installeerimine.
Raivo Laanemets
12. august 2004
*/

mysql_query("CREATE TABLE " .$_SESSION['saidi_nimi'] ."_gb (
  id int PRIMARY KEY,
  nimi char(50),
  email char(100),
  koduleht char(100),
  tekst text,
  aeg int
)") or die('Ei suutnud tabelit luua. ' .mysql_error());

mysql_query("CREATE TABLE " .$_SESSION['saidi_nimi'] ."_gb_conf (
  muutuja char(20) PRIMARY KEY,
  vaartus text
)") or die('Ei suutnud tabelit luua. ' .mysql_error());

mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_gb_conf VALUES ('label', 'font-family: verdana; font-size: 12pt; font-weight: bold')");
mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_gb_conf VALUES ('input', 'font-family: verdana; font-size: 12pt; border: 1px solid #333333')");
mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_gb_conf VALUES ('output', 'font-family: verdana; font-size: 12pt; font-weight: bold; color: #557733')");

?>
Guestbook installeeritud.