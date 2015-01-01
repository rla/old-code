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

$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_lehed") or mysql_error();
while($result=mysql_fetch_row($res)) print '<a href="?mis=objekt&amp;objekt=' .$result[0] .'">' .$result[0] .'</a><br>';

?>

<h2>Lisa leht</h2>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="lisa_leht">
<select name="leht">
<?php
	$olemasolevad_lehed=array();
	$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_lehed");
    while($result=mysql_fetch_row($res)) array_push($olemasolevad_lehed, $result[0]);
    $res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_sisu");
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