<h1>Saidid</h1>
<?php

/*
saidid.php
Saitide administreerimise liides.
Raivo Laanemets
23. juuli 2004

Andmebaasis on saidid tabelis saidid

Tabel sisaldab järgmisi välju:
	saidi_nimi: char(50)
    saidi_tee: char(250)
    saidi_id: int
*/

if ($_SESSION['kasutaja']!='root'):
    $saidid=array();
	$res=mysql_query("SELECT saidi_id FROM kasutaja_saidid WHERE kasutaja_id=" .$_SESSION['kasutaja_id'] ."");
	while($result=mysql_fetch_array($res)) {
		array_push($saidid, $result[0]);
	}
    if (count($saidid)==0) array_push($saidid, -1);
	$res=mysql_query("SELECT saidi_nimi,saidi_id,base,saidi_tee FROM saidid WHERE saidid.saidi_id IN (" .implode(',' ,$saidid) .")");
else:
	$res=mysql_query("SELECT saidi_nimi,saidi_id,base,saidi_tee FROM saidid");
endif;

while($result=mysql_fetch_array($res)) {
	print '<a href="?mis=sait&amp;sait=' .$result[1] .'&amp;nimi=' .$result[0] .'&amp;baas=' .$result[2] .'&amp;tee=' .$result[3] .'">' .$result[0] .'</a> -
    <a href="?mis=saidi_info&amp;sait=' .$result[1] .'&amp;nimi=' .$result[0] .'&amp;baas=' .$result[2] .'&amp;tee=' .$result[3] .'">info</a><br>';
}

if ($_SESSION['kasutaja']=='root'): print '<h2>Lisa</h2>
	<form method="post" action="index.php">
	<input name="mis" type="hidden" value="lisa_sait">
	Saidi nimi:<br>
	<input type="text" name="nimi"><br>
	Saidi tee:<br>
	<input name="tee" type="text" value=""><br>
	Andmebaas:<br>
	<input name="base" type="text" value="' .$_SESSION['baas'] .'"><br><br>
	<input type="submit" value="Lisa">
	</form>
	<h2>Kustuta</h2>
	<form action="index.php" method="post">
	<input name="mis" type="hidden" value="kustuta_sait">
	<select name="sait">';

	$res=mysql_query("SELECT saidi_nimi,saidi_id FROM saidid");
	while($result=mysql_fetch_array($res)) {
		print '<option value="' .$result[1] .'">' .$result[0] .'</option>';
	}

	print '</select><input type="submit" value="Kustuta"></form>';
endif;

?>