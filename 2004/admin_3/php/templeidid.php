<h1>Templeidid</h1>
<?php

/*
templeidid.php
Lehekülje templeitide lisamine, kustutamine ja muutmine.
Raivo Laanemets
28. juuli 2004
*/

mysql_select_db($_SESSION['saidi_baas']);

$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_templeidid");
while($result=mysql_fetch_row($res)) print '<a href="?mis=templeit&amp;id=' .$result[0] .'">' .$result[0] .'</a><br>';

?>
<h2>Lisa</h2>
<form method="post" action="index.php">
<input type="hidden" name="mis" value="lisa_templeit">
Nimi:<br>
<input name="nimi" type="text" value="">
<input type="submit" value="Lisa">
</form>
<h2>Kustuta</h2>
<form method="post" action="index.php">
<input type="hidden" name="mis" value="kustuta_templeit">
<select name="templeit">
	<?php
        $res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_templeidid");
		while($result=mysql_fetch_row($res)) print '<option value="' .$result[0] .'">' .$result[0] .'</option>';
    ?>
</select>
<input type="submit" value="Kustuta">
</form>