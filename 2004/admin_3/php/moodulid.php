<h1>Moodulid</h1>
<?php

/*
moodulid.php
Moodulite lisamine ja eemaldamine.
Raivo Laanemets
12. august 2004
*/

print '<h2>Saidi "' .$_SESSION['saidi_nimi'] .'" moodulid</h2>';

mysql_select_db($_SESSION['saidi_baas']);
$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_moodulid");
while($result=mysql_fetch_row($res)) print '&nbsp;&nbsp;<a href="?mis=moodul&amp;moodul=' .$result[0] .'">' .$result[0] .'</a><br>';

?>
<h2>Lisa</h2>
<form action="index.php" method="post">
<input name="mis" type="hidden" value="lisa_moodul">
<select name="moodul">
<?php
	$d=dir('moodulid');
    while(false!==($entry=$d->read())) if ($entry!='.' && $entry!='..') print '<option value="' .$entry .'">' .$entry .'</option>';
    $d->close();
?>
</select>
<input type="submit" value="Lisa">
</form>