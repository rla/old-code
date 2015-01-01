<?php

/*
kasutaja.php
Ühe kasutaja õiguste määramine.
Raivo Laanemets
23. juuli 2004
*/

print '<h1>Kasutaja ' .$_GET['kasutaja'] .'</h1><h2>Juurdepääsuga saidid:</h2>';

if ($_GET['kasutaja']!='root'):
	$saidid=array();
	$res=mysql_query("SELECT saidi_id FROM kasutaja_saidid WHERE kasutaja_id=" .$_GET['id'] ."");
	while($result=mysql_fetch_array($res)) {
		array_push($saidid, $result[0]);
	}
    if (count($saidid)==0) array_push($saidid, -1);
	$res=mysql_query("SELECT saidi_nimi FROM saidid WHERE saidid.saidi_id IN (" .implode(',' ,$saidid) .")");
else:
	$res=mysql_query("SELECT saidi_nimi FROM saidid");
endif;
while($result=mysql_fetch_array($res)) {
	print $result[0] .'<br>';
}

if ($_GET['kasutaja']!='root'):
	print '<h2>Lisa sait</h2><form method="post" action="index.php">
	<input name="mis" type="hidden" value="lisa_kasutaja_sait">
    <input name="kasutaja_id" type="hidden" value="' .$_GET['id'] .'">
	<select name="sait">';

	$res=mysql_query("SELECT saidi_nimi,saidi_id FROM saidid WHERE saidi_id NOT IN (" .implode(',' ,$saidid) .")");
	while($result=mysql_fetch_array($res)) {
		print '<option value="' .$result[1] .'">' .$result[0] .'</option>';
	}

	print '</select><br><br><input type="submit" value="Lisa"></form>
    <h2>Eemalda sait</h2><form method="post" action="index.php">
	<input name="mis" type="hidden" value="eemalda_sait">
    <input name="kasutaja_id" type="hidden" value="' .$_GET['id'] .'">
	<select name="sait">';

	$res=mysql_query("SELECT saidi_nimi,saidi_id FROM saidid WHERE saidi_id IN (" .implode(',' ,$saidid) .")");
	while($result=mysql_fetch_array($res)) {
		print '<option value="' .$result[1] .'">' .$result[0] .'</option>';
	}

	print '</select><br><br><input type="submit" value="Eemalda"></form>';
endif;
?>