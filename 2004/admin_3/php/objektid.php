<h1>Objektid</h1>
<?php

/*
objektid.php
Objektide list ja muutmine.
Raivo Laanemets
25. juuli 2004
*/

print '<h2>Saidi ' .$_SESSION['saidi_nimi'] .' objektid</h2>';

mysql_select_db($_SESSION['saidi_baas']);
$objektid=array(); $tyybid=array();
$res=mysql_query("SELECT id,tyyp FROM " .$_SESSION['saidi_nimi'] ."_sisu");
while($result=mysql_fetch_array($res)) { array_push($objektid, $result[0]); $tyybid[$result[0]]=$result[1]; }
$objektid=array_unique($objektid);
foreach($objektid as $value) print '<a href="?mis=objekt&amp;objekt=' .$value .'&amp;tyyp=' .$tyybid[$value] .'">' .$value .'</a><br>';

?>
<h2>Lisa</h2>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="lisa_objekt">
Nimi:<br>
<input name="nimi" type="text" value=""><br>
Tüüp:<br>
<select name="tyyp">
	<option value="php">Php</option>
    <option value="html">Html</option>
    <option value="text">Text</option>
    <option value="css">Css</option>
    <option value="thtml">Thtml</option>
</select><br>
Templeit:<br>
<select name="templeit">
<?php
$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_templeidid");
while($result=mysql_fetch_row($res)) print '<option value="' .$result[0] .'">' .$result[0] .'</a>';
?>
</select>
<input type="submit" value="Lisa">
</form>
<h2>Kustuta</h2>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="kustuta_objekt">
<select name="objekt">
	<?php
    $objektid=array();
	$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_sisu");
	while($result=mysql_fetch_array($res)) array_push($objektid, $result[0]);
	$objektid=array_unique($objektid);
    foreach($objektid as $value) print '<option value="' .$value .'">' .$value .'</option>';
    ?>
</select>
<input type="submit" value="Kustuta">
</form>