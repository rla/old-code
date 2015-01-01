<h1>Saidid</h1>
<?php

/*
saidi_info.php
Saidi infot (keeled jms.) näitav skript.
Raivo Laanemets
02. august 2004
*/

print '<h2>Saidi "' .$_GET['nimi'] .'" info</h2>
Andmebaas: <b>' .$_GET['baas']
.'</b><br>Failitee: <b>' . $_GET['tee'] .'</b>';

print '<h2>Keeled</h2>';
$res=mysql_query("SELECT id FROM " .$_GET['nimi'] ."_keeled");
while($result=mysql_fetch_row($res)) print $result[0] .'<br>';

?>

<h2>Lisa keel</h2>
<form action="index.php" method="post">
<input name="nimi" type="hidden" value="<?php echo $_GET['nimi'] ?>">
<input name="baas" type="hidden" value="<?php echo $_GET['baas'] ?>">
<input name="mis" type="hidden" value="lisa_keel">
Lühend(2 tähte):<br>
<input name="keel" type="text" style="width: 20pt">
<input type="submit" value="Lisa">
</form>