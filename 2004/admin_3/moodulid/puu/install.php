<?php

/*
Puu mooduli installeerimine.
Raivo Laanemets
16. september 2004
*/

mysql_query("DROP TABLE IF EXISTS " .$_SESSION['saidi_nimi'] ."_puu");

mysql_query("CREATE TABLE " .$_SESSION['saidi_nimi'] ."_puu (
  nimi char(50) PRIMARY KEY,
  leht char(50),
  lft int,
  rgt int
)") or die('Ei suutnud tabelit luua. ' .mysql_error());

mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_puu VALUES
('juur', '-', 1, 4), ('leht1', '-', 2, 3)
");

?>
Puu installeeritud.