<h1>Lehed</h1>
<?php

/*
lehed.php
Lehekülgede haldus
Raivo Laanemets
25. juuli 2004
*/

print '<h2>Saidi ' .$_SESSION['saidi_nimi'] .' lehed:</h2>';

$res=mysql_query("SELECT base,saidi_nimi FROM saidid WHERE saidi_id='" .$_SESSION['sait'] ."'");
mysql_select_db($result[0]);

$res=mysql_query("SELECT t1.id,t2.tyyp FROM " .$_SESSION['saidi_nimi'] ."_lehed AS t1, " .$_SESSION['saidi_nimi'] ."_sisu AS t2 WHERE (t1.id=t2.id) GROUP BY t1.id") or print mysql_error();
while($result=mysql_fetch_row($res)) print '<a href="?mis=objekt&amp;objekt=' .$result[0] .'&amp;tyyp=' .$result[1] .'">' .$result[0] .'</a><br>';

?>

<h2>Lisa leht</h2>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="lisa_leht">
<select name="leht">
<?php
	$olemasolevad_lehed=array();
	$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_lehed");
    while($result=mysql_fetch_row($res)) array_push($olemasolevad_lehed, $result[0]);

    $res=mysql_query("SELECT id,tyyp FROM " .$_SESSION['saidi_nimi'] ."_sisu WHERE NOT (tyyp='css') AND NOT(id='main') AND id NOT IN ('" .implode('\',\'', $olemasolevad_lehed) ."')");
    while($result=mysql_fetch_row($res)) print '<option value="' .$result[0] .'">' .$result[0] .'</option>';
?>
</select>
<input type="submit" value="Lisa">
</form>
<h2>Kustuta</h2>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="kustuta_leht">
<select name="leht">
<?php
	$olemasolevad_lehed=array();
	$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_lehed");
    while($result=mysql_fetch_row($res)) print '<option value="' .$result[0] .'">' .$result[0] .'</option>';
?>
</select>
<input type="submit" value="Kustuta">
</form>