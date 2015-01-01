<h1>Pealkirjad</h1>
<?php

/*
pealkirjad.php
Lehekülgede pealkirjade muutmine.
Raivo Laanemets
13.august 2004
*/

mysql_select_db($_SESSION['saidi_baas']);
$res=mysql_query("SELECT t1.id,t2.pealkiri FROM " .$_SESSION['saidi_nimi'] ."_lehed AS t1," .$_SESSION['saidi_nimi'] ."_sisu AS t2 WHERE (t1.id=t2.id) GROUP BY t1.id");
while($result=mysql_fetch_row($res)) print '<a href="?mis=pealkiri&amp;leht=' .$result[0] .'&amp;pealkiri=' .$result[1] .'">' .$result[0] .'</a> - ' .$result[1] .'<br>';

?>